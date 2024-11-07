import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
# job.init(args['JOB_NAME'], args)
# job.commit()

dynamicFrameCustomers = glueContext.create_dynamic_frame.from_catalog(
database = "pyspark_tutorial_db", 
table_name = "customers"
)

dynamicFrameCustomers.show(10)

dyfCustomerDropFields = dynamicFrameCustomers.drop_fields(["firstname","lastname"])


glueContext.write_dynamic_frame.from_options(
                        frame = dyfCustomerDropFields,
                        connection_type="s3", 
                        connection_options = {"path": "s3://shraddha-pyspark-data/write_down_dyf_to_s3/output.csv"}, 
                        format = "csv", 
                        format_options={
                            "separator": ","
                            },
                        transformation_ctx = "datasink2")
