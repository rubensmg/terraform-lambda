data "archive_file" "main" {
  type        = "zip"
  output_path = "${var.path}.zip"
  source_dir  = "../${var.path}/"
}

output "output" {
  value = data.archive_file.main.output_path
}
