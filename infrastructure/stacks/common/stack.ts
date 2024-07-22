import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as secretsmanager from 'aws-cdk-lib/aws-secretsmanager';
import * as events from 'aws-cdk-lib/aws-events';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as dotenv from 'dotenv';

dotenv.config({
  path: './stacks/common/.env',
  override: true,
  // debug: true
});

const AIAgentsEnginePrefx = 'ProezaAIAgentsEngine';
const secretsName = `${AIAgentsEnginePrefx}Secrets`;
const eventBusName = `${AIAgentsEnginePrefx}EventBus`;

const openAiKey = process.env.OPEN_AI_KEY || '';
const llamaCloudApiKey = process.env.LLAMA_CLOUD_API_KEY || '';

export class CommonStack extends cdk.Stack {
  apiName: string;
  apiArn: string;
  apiId: string;
  apiRootResourceId: any;
  secretName: string;
  secretArn: string;
  eventBusName: string;
  eventBusArn: string;

  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create an API Gateway REST API
    const api = new apigateway.RestApi(this, `${AIAgentsEnginePrefx}Api`, {
      defaultCorsPreflightOptions: {
        allowOrigins: apigateway.Cors.ALL_ORIGINS,
        allowMethods: apigateway.Cors.ALL_METHODS,
        allowHeaders: apigateway.Cors.DEFAULT_HEADERS,
      }
    });

    // Export the API restID and Root Resource ID
    this.apiId = api.restApiId;
    this.apiRootResourceId = api.restApiRootResourceId;

    new cdk.CfnOutput(this, 'ApiIdOutput', {
      value: this.apiId,
      exportName: 'MainApiId',
    });

    new cdk.CfnOutput(this, 'ApiRootResourceIdnOutput', {
      value: this.apiRootResourceId,
      exportName: 'MainApiResourceId',
    });

    const secret = new secretsmanager.Secret(this, secretsName, {
      secretName: secretsName,
      description: 'Common Secrets',
      secretObjectValue: {
        OPEN_AI_KEY: cdk.SecretValue.unsafePlainText(openAiKey),
        LLAMA_CLOUD_API_KEY: cdk.SecretValue.unsafePlainText(llamaCloudApiKey),
      }
    });

    // Export the secret name and ARN
    this.secretName = secretsName;
    this.secretArn = secret.secretArn;

    new cdk.CfnOutput(this, 'SecretNameOutput', {
      value: this.secretName,
      exportName: 'CommonSecretName',
    });

    new cdk.CfnOutput(this, 'SecretArnOutput', {
      value: this.secretArn,
      exportName: 'CommonSecretArn',
    });


    // Create the custom Event Bus
    const eventBus = new events.EventBus(this, eventBusName, {
      eventBusName: eventBusName,
    });
    
    // Export the Event Bus name and ARN
    this.eventBusName = eventBus.eventBusName;
    this.eventBusArn = eventBus.eventBusArn;
    new cdk.CfnOutput(this, 'EventBusNameOutput', {
      value: this.eventBusName,
      exportName: 'CommonEventBusName',
    });

    new cdk.CfnOutput(this, 'EventBusArnOutput', {
      value: this.eventBusArn,
      exportName: 'CommonEventBusArn',
    });


    // Define the S3 bucket for raw documents
    const rawDocumentsBucket = new s3.Bucket(this, 'RawDocuments', {
      removalPolicy: cdk.RemovalPolicy.DESTROY, // Only for development purposes
      autoDeleteObjects: true, // Only for development purposes
    });

    // Export the bucket name
    new cdk.CfnOutput(this, 'BucketRawDocuments', {
      value: rawDocumentsBucket.bucketName,
      exportName: 'RawDocumentsBucketName',
    });

    // Define the S3 bucket for raw documents
    const parsedDocumentsBucket = new s3.Bucket(this, 'ParsedDocuments', {
      removalPolicy: cdk.RemovalPolicy.DESTROY, // Only for development purposes
      autoDeleteObjects: true, // Only for development purposes
    });

    // Export the bucket name
    new cdk.CfnOutput(this, 'BucketParsedDocuments', {
      value: parsedDocumentsBucket.bucketName,
      exportName: 'ParsedDocumentsBucketName',
    });

    // Pipedrive API callback endpoint
    // Function
    const pipedriveCallbackFunc = new lambda.Function(this, 'PipedriveCallback', {
      functionName: 'PipedriveCallback',
      runtime: lambda.Runtime.PYTHON_3_12,
      handler: 'init.lambda_handler',
      code: lambda.Code.fromAsset('../source/common/pipedrive_callback'),
      architecture: lambda.Architecture.ARM_64,
      timeout: cdk.Duration.seconds(12),
      environment: {}
    });
    const pipedriveCallbackRes = api.root.addResource('pipedrive-callback');
    // Create a POST method on the pipedrive-callback resource
    pipedriveCallbackRes.addMethod('POST', new apigateway.LambdaIntegration(pipedriveCallbackFunc));
  }
}
