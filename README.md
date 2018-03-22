# terraform_modules

This is a group of terraform modules managed by Table XI (@tablexi). Most of these modules are things we do on every project. This has been made open source so you can see some examples.

### WARNING!!
---
Use this it at your own risk. If you are brave enough to use undocumented modules please use them with a commit SHA1 module reference (see example below).

```hcl
module "example-com-replica-mysql" {
   source    = "github.com/tablexi/terraform_modules?ref=05ce01e//aws/rds"
   ...
}
```
### Development

##### Planshots
For testing of these modules we created a technique called `planshots` (based on the same principals as [Jest's Snapshot testing](https://facebook.github.io/jest/docs/en/snapshot-testing.html)). We have a series of directories throughout the codebase called `__examples__`, inside of which are some examples of how to use the modules that are being defined in that directory. The planshot tool will generate a `terraform plan` for each of those directories and store it in a planshots.txt file. On each build we confirm that what is in the planshots.txt is what the planshots binary would generate. This does two things:
* Force's developers to see the ramifications of the changes to modules that they edit
* Allows reviewers to see the `terraform plan` that gets caused by changes when doing PR review

Running the planshots presumes that you have at least some AWS credentials setup in your environment. [Here](https://www.terraform.io/docs/providers/aws/#environment-variables) are some instructions on how to do this. No changes will be made to the AWS account in question.

---
Running Planshots:

* `bin/planshots`               - Runs all planshots in the entire project and errors on differences from what is currently in each planshots.txt file
* `bin/planshots aws/ec2/`      - Runs only planshots inside of the aws/ec2 directory
* `GENERATE=true bin/planshots` - Runs all planshots in the entire project and rewrites all planshots.txt files

---
