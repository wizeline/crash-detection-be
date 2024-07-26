from init import lambda_handler

event = {
   "Records":[
      {
         "eventVersion":"2.1",
         "eventSource":"aws:s3",
         "awsRegion":"us-west-2",
         "eventTime":"2024-07-01T18:03:28.630Z",
         "eventName":"ObjectCreated:Put",
         "userIdentity":{
            "principalId":"AWS:AROA5FTZCJRQSB3DZBKSG:cesar.reyes@wizeline.com"
         },
         "requestParameters":{
            "sourceIPAddress":"177.249.171.174"
         },
         "responseElements":{
            "x-amz-request-id":"F3B1R5DSHQ5WYZ8B",
            "x-amz-id-2":"u9biDfqYVwLL+zY01BdQZMHMwQxNaYKlo7MkL1ZNpnTY3v/4p8xBTLmD1M/XZ/gxr71/yNN0EJkZ+tlOiB60IDMz7WDSkFtq"
         },
         "s3":{
            "s3SchemaVersion":"1.0",
            "configurationId":"arn:aws:cloudformation:us-west-2:905418263649:stack/ProezaDataParsingStack/52df08d0-35a1-11ef-abc8-06dd73953739--6438105459230602271",
            "bucket":{
               "name":"proezacommonstack-rawdocuments508574c6-ihqitou9a1fh",
               "ownerIdentity":{
                  "principalId":"A3GMLHI0WIR7DM"
               },
               "arn":"arn:aws:s3:::proezacommonstack-rawdocuments508574c6-ihqitou9a1fh"
            },
            "object":{
               "key":"integra.zip",
               "size":1210132,
               "eTag":"4afbfc8dceb517f5ba4c71e1969c91fc",
               "sequencer":"006682EF708096866C"
            }
         }
      }
   ]
}

lambda_handler(event, {})