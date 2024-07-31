import json
import app
import os

json_file = os.path.join(os.getcwd(), 'source/samples/events/put-bucket.json')

if __name__ == "__main__":
    with open(json_file, 'r') as f:
        event = json.load(f)
    app.lambda_handler(event, "")    
