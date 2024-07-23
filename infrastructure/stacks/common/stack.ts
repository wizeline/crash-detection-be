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

const CDCommonStackPrefix = 'CDCommonStack';
const secretsName = `${CDCommonStackPrefix}Secrets`;
// const eventBusName = `${CDCommonStackPrefix}EventBus`;

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
    const api = new apigateway.RestApi(this, `${CDCommonStackPrefix}Api`, {
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
    // const eventBus = new events.EventBus(this, eventBusName, {
    //   eventBusName: eventBusName,
    // });
    
    // // Export the Event Bus name and ARN
    // this.eventBusName = eventBus.eventBusName;
    // this.eventBusArn = eventBus.eventBusArn;
    // new cdk.CfnOutput(this, 'EventBusNameOutput', {
    //   value: this.eventBusName,
    //   exportName: 'CommonEventBusName',
    // });

    // new cdk.CfnOutput(this, 'EventBusArnOutput', {
    //   value: this.eventBusArn,
    //   exportName: 'CommonEventBusArn',
    // });


    // Define the S3 bucket for raw videos
    const rawVideosBucket = new s3.Bucket(this, 'RawVideos', {
      removalPolicy: cdk.RemovalPolicy.DESTROY, // Only for development purposes
      autoDeleteObjects: true, // Only for development purposes
    });

    // Export the bucket name
    new cdk.CfnOutput(this, 'CommonRawVideosBucket', {
      value: rawVideosBucket.bucketName,
      exportName: 'CommonRawVideosBucketName',
    });

    // Define the S3 bucket for video chunks
    const VideoChunksBucket = new s3.Bucket(this, 'CommonBucketVideoChunks', {
      removalPolicy: cdk.RemovalPolicy.DESTROY, // Only for development purposes
      autoDeleteObjects: true, // Only for development purposes
    });

    // Export the bucket name
    new cdk.CfnOutput(this, 'CommonVideoChunksBucket', {
      value: VideoChunksBucket.bucketName,
      exportName: 'ParsedVideoChunksBucketName',
    });

    
  }
}
