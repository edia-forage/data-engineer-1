# dataengineer-forage


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

gcloud dataflow flex-template run "test-anz-trans-job1" --template-file-gcs-location $TEMPLATE_PATH \\n--parameters input="gs://anz-raw-anz-bigdata/systemA/anz_transaction.csv" \\n--parameters output="gs://anz-transformed-anz-bigdata/systemA/transformed1/" \\n--parameters input-schema="gs://anz-raw-anz-bigdata/systemA/schemas/input.sch" \\n--parameters output-schema="gs://anz-raw-anz-bigdata/systemA/schemas/trans.avsc" \\n--region "asia-south1"


