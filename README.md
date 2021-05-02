# dataengineer-forage

## Initial Setup of the project

After creating your GCP project, please enable following API services.

a. Compute Engine API

b. Cloud Build API

c. DataFlow API

d. Identity and Access Management (IAM) API	

e. Cloud Monitoring 


## Structure of the project

terraform - Contains all the infrastrcutre configuration required to run the dataflow jobs. From vpc to buckets etc.

dataflow - python module contains the definition of data pipeline.

input - input data file

schemas - schema files to read & write.

## Cloud build setup

terraform/infra-cloudbuild.yaml   -- Configure cloudbuild trigger to run while merging anything to dev branch to deploy all infra changes.

deploy-cloudbuild.yaml - Configure another cloudbuild tigger to run the job template as container build & move all the metadata to gcs.


## To Build Dataflow template as docker

a. Run the cloud build command or setup cloud build trigger for the repository.

gcloud builds submit --config deploy-cloudbuild.yaml

b. Create DataFlow Flex Template

export TEMPLATE_PATH="gs://anz-dataflow-templates/latest/anz-data-flow/anz-trans-modifier.json"

gcloud dataflow flex-template build $TEMPLATE_PATH \
--image "gcr.io/anz-bigdata/anz-trans-modifier" \
--sdk-language "PYTHON" \
--metadata-file "dataflow/metadata.json"

## To run a sample job

gcloud dataflow flex-template run "test-anz-trans-job1" \
--template-file-gcs-location $TEMPLATE_PATH \
--parameters input="gs://anz-raw-anz-bigdata/systemA/anz_transaction.csv" \
--parameters output="gs://anz-transformed-anz-bigdata/systemA/transformed1/" \
--parameters input-schema="gs://anz-raw-anz-bigdata/systemA/schemas/input.sch" \
--parameters output-schema="gs://anz-raw-anz-bigdata/systemA/schemas/trans.avsc" \
--region "asia-south1"


