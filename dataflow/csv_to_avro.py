import argparse
import logging

import apache_beam as beam
from apache_beam.io.filesystems import FileSystems
from apache_beam.io import ReadFromText
from apache_beam.io import WriteToAvro
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.options.pipeline_options import SetupOptions
from fastavro import parse_schema
import json
 

class CSVToAvroDoFn(beam.DoFn):
    ''' Class converts csv record into dictionary comatible avro format'''

    def __init__(self, csvSchema):
        self.inputSchema = bytes.decode(csvSchema, encoding='utf-8')

    def process(self, record):
        fields = record.split(",")

        row = dict(zip(self.inputSchema.split(","), fields))

        return [row]

class Split(beam.DoFn):
    ''' Splits given field in dict or avro record into given 2 new fields.
        The splitter is a "empty space". '''
    
    def __init__(self, split_col, new1, new2):
        self.split_col = split_col
        self.new1 = new1
        self.new2 = new2

    def process(self, record):
        field_value = record[self.split_col]
        split_vals = field_value.split(" ")
        record.pop(self.split_col)
        record[self.new1] = split_vals[0]
        if len(split_vals) > 1:
            record[self.new2] = split_vals[1]
        else:
            record[self.new2] = ""
        return [record]

def run(argv=None, save_main_session=True):
    """Main entry point; defines and runs the wordcount pipeline."""

    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--input',
        dest='input',
        default='gs://anz-raw-anz-bigdata/systemA/anz_transaction.csv',
        help='Input file to process.')
    parser.add_argument(
        '--output',
        dest='output',
        default='gs://anz-transformed-anz-bigdata/systemA/transformed/',
        help='Output file to write results to.')
    parser.add_argument(
        '--input-schema',
        dest='input_schema',
        default='gs://anz-raw-anz-bigdata/systemA/schemas/input.sch',
        help='Input schmea to load.')
    parser.add_argument(
        '--output-schema',
        dest='output_schema',
        default='gs://anz-raw-anz-bigdata/systemA/schemas/trans.avsc',
        help='output avro schema to write')
    known_args, pipeline_args = parser.parse_known_args(argv)
    pipeline_args.extend([
        '--runner=DirectRunner',
        '--project=anz-bigdata',
        '--region=asia-south1',
        '--staging_location=gs://anz-transformed-anz-bigdata/staging',
        '--temp_location=gs://anz-transformed-anz-bigdata/temp',
        '--job_name=anz-trans-filter',
    ])


    pipeline_options = PipelineOptions(pipeline_args)
    pipeline_options.view_as(SetupOptions).save_main_session = save_main_session

    avro_schema = parse_schema(json.loads(
        FileSystems.open(
            path=known_args.output_schema).read()))
    
    csv_schema = FileSystems.open(
            path=known_args.input_schema).read()
    
    with beam.Pipeline(options=pipeline_options) as p:
        
        records = p | ReadFromText(known_args.input, skip_header_lines=1)

        (
            records
            | 'convert' >> (
                beam.ParDo(CSVToAvroDoFn(csv_schema)))
            |  "split long_lat" >> (
                beam.ParDo(Split("long_lat", "long", "lat")))
            |  "split marchant_long_lat" >> (
                beam.ParDo(Split("merchant_long_lat", "merchant_long", "merchant_lat")))
            | beam.Filter( lambda row: 
                row["status"] == "authorized"
                and row["card_present_flag"] == "0" )
            | WriteToAvro('output/test.avro', schema=avro_schema)
        )

if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    run()
