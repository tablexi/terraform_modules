# terraform_modules

A group of terraform modules managed by Table XI (@tablexi). Most of these modules are things we do on every project. This has been made open source so you can see some examples.

---
---
**WARNING:** If you use this do it at your own risk. If you are brave enough to use undocumented modules please use them with a commit SHA1 module refence (see example below).

```hcl
module "example-com-replica-mysql" {
   source    = "github.com/tablexi/terraform_modules?ref=05ce01e//aws/rds"
   ...
}
```
---
---

