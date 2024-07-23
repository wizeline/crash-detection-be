# Lambda Layers Builder Script

This shell script is used to generate Python layers for AWS Lambda functions. It utilizes Docker to create a consistent build environment and packages the specified Python dependencies into a ZIP file suitable for use as a Lambda layer.

## Requirements

- Docker must be installed and running on your system.
- A `requirements.txt` file specifying the Python dependencies to be included in the layer.

## Usage

```sh
./runner.sh -r <requirements> [-o <output>]
```

## Options

- -r, --requirements: (Mandatory) Specify the full path to the requirements.txt file.
- -o, --output: (Optional) Specify the output filename (without extension). Default is python. The resulting file will have a .zip extension and will be located in the layers folder.
- --help: Display the help message.

# Examples

## Basic Usage

To generate a Python layer using the requirements.txt file:

```sh
./runner.sh -r /path/to/requirements.txt
```

This command will create a file named python.zip in the layers folder.

## Custom Output Filename

To specify a custom output filename:

```sh
./runner.sh -r /path/to/requirements.txt -o custom_layer_name
```
Sample for this project:

```sh
./runner.sh -r requirements_pillow.txt -o ../../layers/pillow
```


This command will create a file named custom_layer_name.zip in the layers folder.

## Help

To display the help message:

```sh
./runner.sh --help
```