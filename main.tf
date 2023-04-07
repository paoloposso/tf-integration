resource "aws_dynamodb_table" "table1" {
    server_side_encryption {
        kms_key_arn= "arn:{redacted}"
    }

    hash_key = "exampleHashKey"

    attribute {
        name = "GameTitle"
        type = "S"
    }

    global_secondary_index {
        name               = "GameTitleIndex"
        hash_key           = "GameTitle"
        range_key          = "TopScore"
        write_capacity     = 10
        read_capacity      = 10
        projection_type    = "INCLUDE"
        non_key_attributes = ["UserId"]
    }

    replica {
        region_name = "us-west-2"
    }
}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.table1.name
  hash_key   = aws_dynamodb_table.table1.hash_key

  item = <<ITEM
{
  "exampleHashKey": {"S": "something"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM
}