import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as secretsmanager from 'aws-cdk-lib/aws-secretsmanager';
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as s3n from 'aws-cdk-lib/aws-s3-notifications';
import * as events from 'aws-cdk-lib/aws-events';
import * as targets from 'aws-cdk-lib/aws-events-targets';


// const eventSource = 'com.wizeline.proeza-samples-agents-engine.api';
// const eventDetailType = 'agent-app-execution';

export class SampleStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Import the API Id and Root Resource Id
    const apiId = cdk.Fn.importValue('MainApiId');
    const rootResourceId = cdk.Fn.importValue('MainApiResourceId');
    const api = apigateway.RestApi.fromRestApiAttributes(this, 'MainImportedApi', {
      restApiId: apiId,
      rootResourceId: rootResourceId,
    });

    // Import the secret ARN
    const secretArn = cdk.Fn.importValue('CommonSecretArn');
    const CommonSecret = secretsmanager.Secret.fromSecretAttributes(this, 'CommonSecret', {
      secretCompleteArn: secretArn,
    });

    // Sample how to Import the secret value
    // const openAiKey = secret.secretValueFromJson('OPEN_AI_KEY').toString();

    // Import the existing Event Bus using its ARN
    // const commonEventBusArn = cdk.Fn.importValue('CommonEventBusArn');
    // const commonEventBus = events.EventBus.fromEventBusArn(this, 'CommonEventBus', commonEventBusArn);
    // // Define the rule
    // const pingRule = new events.Rule(this, 'AIAgentsEnginePingRule', {
    //   ruleName: 'AIAgentsEnginePingRule',
    //   eventBus: commonEventBus,
    //   eventPattern: {
    //     "source": [eventSource],
    //     "detailType": [eventDetailType],
    //     "detail": {
    //       "var1": [{
    //         "equals-ignore-case": "value1"
    //       }],
    //       "var2": [{
    //         "equals-ignore-case": "value2"
    //       }]
    //     }
    //   }
    // });

    // Import the Raw Videos Bucket using its name
		const rawVideosBucketName = cdk.Fn.importValue('CommonRawVideosBucketName');
		const rawVideosBucket = s3.Bucket.fromBucketName(this, 'ImportedRawVideosBucket', rawVideosBucketName);

    // Define the pillow Lambda Layer
    const pillowLayer = new lambda.LayerVersion(this, 'PillowLayer', {
      code: lambda.Code.fromAsset('../layers/pillow.zip'),
      compatibleRuntimes: [lambda.Runtime.PYTHON_3_12],  // Adjust runtime as needed
      description: 'Pillow Layer',
    });

    // Define the pyAV lambda Layer
    const pyavLayer = new lambda.LayerVersion(this, 'PyAVLayer', {
      code: lambda.Code.fromAsset('../layers/pyAV.zip'),
      compatibleRuntimes: [lambda.Runtime.PYTHON_3_12],  // Adjust runtime as needed
      description: 'PyAV Layer',
    });

    // Simple Function
    const simpleFunc = new lambda.Function(this, 'SampleSimpleFunction', {
      functionName: 'SampleSimpleFunction',
      runtime: lambda.Runtime.PYTHON_3_12,
      handler: 'lambda.lambda_handler',
      code: lambda.Code.fromAsset('../source/samples/simple_lambda'),
      architecture: lambda.Architecture.ARM_64,
      timeout: cdk.Duration.seconds(12),
      layers: [pillowLayer, pyavLayer],
      environment: {
        SECRETS_NAME: CommonSecret.secretName,
        // EVENT_BUS_ARN: commonEventBusArn,
        // EVENT_SOURCE: eventSource,
        // EVENT_DETAIL_TYPE: eventDetailType
      }
    });

    // Create a resource with the path 'sample-path'
    const samplePath = api.root.addResource('sample-path');

    // Create a POST method on the sample-path resource
    samplePath.addMethod('POST', new apigateway.LambdaIntegration(simpleFunc));

    // Grant the function read access to the secret
    CommonSecret.grantRead(simpleFunc);

    // Grant the Lambda function permissions on the S3 buckets
		rawVideosBucket.grantRead(simpleFunc);

    // Add S3 event notification to trigger Lambda function on object creation (prefixes can be adjusted to detect new folders)
		rawVideosBucket.addEventNotification(
			s3.EventType.OBJECT_CREATED,
			new s3n.LambdaDestination(simpleFunc),
			{ prefix: '', suffix: '.mp4' } // Trigger only for .mp4 files
		);


    // Grant the Lambda permission to put events to the Event Bus
    // commonEventBus.grantPutEventsTo(simpleFunc);
    // pingRule.addTarget(new targets.LambdaFunction(simpleFunc));

    // Docker lambda function
		const dockerFunction = new lambda.DockerImageFunction(this, 'SampleDockerFunction', {
			functionName: 'SampleDockerFunction',
			code: lambda.DockerImageCode.fromImageAsset('../source/samples/docker_lambda'),
			memorySize: 1024,
			timeout: cdk.Duration.minutes(10),
			architecture: lambda.Architecture.ARM_64,
			environment: {
				SECRETS_NAME: CommonSecret.secretName,
			}
		});

    
  }
}
