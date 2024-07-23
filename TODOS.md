# Potential Improvements

This is a POC so it is not production code or a fully-fleshed out implementation.  There are many things
that could be differently if the project were to be matured.  Some ideas are:

- Separate the connection and the trigger so there can be multiple triggers and removing one will not remove the conneection.
- Automate the Terraform apply
- Provide a manual trigger for a terraform destroy
- Allow users to specify what to trigger on
- Give the option to seed the GitHub token
- Handle the IAM stuff
- Run each build as a separate service account for security
- alert on failed builds
- alert on missing build definition files
