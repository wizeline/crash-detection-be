import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as secretsmanager from 'aws-cdk-lib/aws-secretsmanager';
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as s3n from 'aws-cdk-lib/aws-s3-notifications';

export class VideoChunkStack extends cdk.Stack {
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

    // Import the Raw Videos Bucket using its name
		const rawVideosBucketName = cdk.Fn.importValue('CommonRawVideosBucketName');
		const rawVideosBucket = s3.Bucket.fromBucketName(this, 'ImportedRawVideosBucket', rawVideosBucketName);

    // Import the Raw Videos Bucket using its name
		const bucketVideoChunksName = cdk.Fn.importValue('CommonBucketVideoChunks');
		const bucketVideoChunks = s3.Bucket.fromBucketName(this, 'ImportedBucketVideoChunks', bucketVideoChunksName);

    // Docker lambda function
		const dockerFunction = new lambda.DockerImageFunction(this, 'VideoChunkDockerFunction', {
			functionName: 'VideoChunkDockerFunction',
			code: lambda.DockerImageCode.fromImageAsset('../../../source/video_chunk_lambda'),
			memorySize: 1024,
			timeout: cdk.Duration.minutes(10),
			architecture: lambda.Architecture.ARM_64,
			environment: {
				SECRETS_NAME: CommonSecret.secretName,
			}
		});

    // Create a resource with the path 'video-chunk-path'
    const videoChunkPath = api.root.addResource('video-chunk-path');

    // Create a POST method on the video-chunk-path resource
    videoChunkPath.addMethod('POST', new apigateway.LambdaIntegration(dockerFunction));

    // Grant the function read access to the secret
    CommonSecret.grantRead(dockerFunction);

    // Grant the Lambda function permissions on the S3 buckets
    bucketVideoChunks.grantReadWrite(dockerFunction);

		rawVideosBucket.grantRead(dockerFunction);

    // Add S3 event notification to trigger Lambda function on object creation (prefixes can be adjusted to detect new folders)
		rawVideosBucket.addEventNotification(
			s3.EventType.OBJECT_CREATED,
			new s3n.LambdaDestination(dockerFunction),
			{ prefix: '', suffix: '.mp4' } // Trigger only for .mp4 files
		);
    
  }
}
