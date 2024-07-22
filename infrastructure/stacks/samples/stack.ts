import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as secretsmanager from 'aws-cdk-lib/aws-secretsmanager';
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as events from 'aws-cdk-lib/aws-events';
import * as targets from 'aws-cdk-lib/aws-events-targets';


const eventSource = 'com.wizeline.proeza-samples-agents-engine.api';
const eventDetailType = 'agent-app-execution';

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
    const commonEventBusArn = cdk.Fn.importValue('CommonEventBusArn');
    const commonEventBus = events.EventBus.fromEventBusArn(this, 'CommonEventBus', commonEventBusArn);
    // Define the rule
    const pingRule = new events.Rule(this, 'AIAgentsEnginePingRule', {
      ruleName: 'AIAgentsEnginePingRule',
      eventBus: commonEventBus,
      eventPattern: {
        "source": [eventSource],
        "detailType": [eventDetailType],
        "detail": {
          "var1": [{
            "equals-ignore-case": "value1"
          }],
          "var2": [{
            "equals-ignore-case": "value2"
          }]
        }
      }
    });

    // Sample Function
    const sampleFunc = new lambda.Function(this, 'SampleFunction', {
      runtime: lambda.Runtime.PYTHON_3_12,
      handler: 'lambda.lambda_handler',
      code: lambda.Code.fromAsset('../source/samples'),
      architecture: lambda.Architecture.ARM_64,
      timeout: cdk.Duration.seconds(12),
      environment: {
        SECRETS_NAME: CommonSecret.secretName,
        EVENT_BUS_ARN: commonEventBusArn,
        EVENT_SOURCE: eventSource,
        EVENT_DETAIL_TYPE: eventDetailType
      }
    });

    // Create a resource with the path 'sample-path'
    const samplePath = api.root.addResource('sample-path');

    // Create a POST method on the sample-path resource
    samplePath.addMethod('POST', new apigateway.LambdaIntegration(sampleFunc));

    // Grant the function read access to the secret
    CommonSecret.grantRead(sampleFunc);

    // Grant the Lambda permission to put events to the Event Bus
    commonEventBus.grantPutEventsTo(sampleFunc);
    pingRule.addTarget(new targets.LambdaFunction(sampleFunc));

    
  }
}
