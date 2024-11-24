# Pagerduty Terraform IaC

<div align=center>
  <img src="https://blogs.vmware.com/cloudprovider/files/2019/04/og-image-8b3e4f7d-blog-aspect-ratio.png" width="200">
  <img src="https://cledara-public.s3.eu-west-2.amazonaws.com/Pagerduty.png" width="150">
</div>

<div align=center>
In this Repository we store all of the <b>Terraform</b> code that is used to managed the <b>Legacy JBOSS Platform</b> Pagerduty configurations.
</div>
<p></p>
<div align=center>
If you are looking for a more in-deepth documentation about Pageduty in general, please have a look into the original <a href="https://confluence-p.internal.epo.org/pages/viewpage.action?spaceKey=EA&title=Pagerduty">Confluence Document</a>. 
</div>

---

## Managed Resources

Currently in this Repository we manage the following Pagerduty Resources:

- The Team `Maist`, and all its corresponding **Users** and **Tags**;
- The **Schedules**. They're declared here and maintained directly in PD;
- The **Escalation Policies**;
- The **Services**, **Business Services**, **Services Dependencies** and some **Integrations**;
- The **Slack Channel Connections**;
- The **Orchestration Rules**.
- The **Service Orchestrations**.

## Limitations

Using the official [Pagerduty Terraform Provider](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs) we still face some limitations on the resources we want to create, mainly the following are the ones we found so far:

- We are facing some licenses limitations on Pagerduty side wich invalidates the possibility for Terraform to create new Users on Pagerduty (since [we cant specify the license that should be used](https://github.com/PagerDuty/terraform-provider-pagerduty/issues/631)). Thanks to this, when new Users are added into Pagerduty, they need to be referenced as new resources in Terraform and then imported using `terraform import pagerduty_user.USER_RESOURCE_NAME USER_ID`;

- Currently using Terraform we can only interact with the Slack Addon by creating\editing Slack Channels mappings into PagerDuty Services. The connection the with Slack Space is something that needs to be done [**manually beforehand**](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/slack_connection#:~:text=To%20first%20use%20this%20resource%20you%20will%20need%20to%20map%20your%20PagerDuty%20account%20to%20a%20valid%20Slack%20Workspace.%20This%20can%20only%20be%20done%20through%20the%20PagerDuty%20UI.);


## Working in this Repository

In this section lets go over a high-level overview on how can anyone interact with this repository and change the resources here acordingly.

For more details please have a look into the [Wiki](https://git.epo.org/platform/tf-pagerduty/wiki).

### Repository Structure and Rules

Currently this repository just as all the resources definitions in their corresponding files without the use of any custom modules. This can and probably will change in the future, to ease the creation of new Users, Teams, Services, etc.

The Resources Files are structured as follows:

- [Tags](00_tags.tf) - Here we manage the Tags that will later on be tagged into the different resources. [Official Docs](https://support.pagerduty.com/docs/contextual-search).
- [Teams](00_teams.tf) - Here we define the Teams we manage. [Official Docs](https://support.pagerduty.com/docs/teams).
- [Users](10_users.tf) - Here we define the Users that should exist and all their configurations, and also associate them to their corresponding groups. [Official Docs](https://support.pagerduty.com/docs/users).
- [Schedules](00_schedules.tf) - Here we define the Schedules and map them to the corresponding Teams. [Official Docs](https://support.pagerduty.com/docs/schedule-basics).
- [Escalation Policies](00_escalation_policies.tf)- Here we define the Escalation Policies and map them to the corresponding teams. [Official Docs](https://support.pagerduty.com/docs/escalation-policies).
- [Services](99_services.tf) - Here we create all the CatchAll services, process the CSV files containing the different types of service, map them to their corresponding Escalation Policies and invoke the proper module to build them.  [Official Docs](https://support.pagerduty.com/docs/service-profile).
- [Business Services](20_services_business.tf) - Here we create all the Business Services. [Official Docs](https://support.pagerduty.com/docs/business-services).
- [Services Dependencies (Infrastructure)](20_services_dependencies_infra.tf) - Here we define the Infrastructure Services Dependencies were we can set what services use and are used by other services. [Official Docs](https://support.pagerduty.com/docs/service-profile#service-dependencies-tab).
- [Services Dependencies (Apps)](20_services_dependencies_apps.tf) - Here we define the Applications Services Dependencies were we can set what services use and are used by other services. [Official Docs](https://support.pagerduty.com/docs/service-profile#service-dependencies-tab).
- [Services Integrations](services.tf) - In the same [module](./modules/service/) we use to create Services we also define their Services Integrations. Currently we are only configuring GitHub (we use the corresponding Github Provider to create and manage the Webhooks on the corresponding Github repos) and Slack. [Official Docs](https://support.pagerduty.com/docs/service-profile#integrations-tab).
- [Orchestration Rules](00_orchestration.tf) - Here we define the Orchestration rules that basically define the workflow of what services should the alerts end up to. [Official Docs](https://support.pagerduty.com/docs/event-orchestration).
- [Modules] (./modules) - There is one module per managed service type (Legacy applications, http instances and JSF services). Each module builds specific attibutes and behaviours to the service type. Service orchestrations are configured inside the modules.
- [Rundeck Option Services] (99_svc_options_generator.tf) - This file generates the different options file for Rundeck based on the service type (AMF-HTTP-JSF). The generated files need to be copied to rundeck installation.
- [Templates] (./templates) - Templates to build the different descriptions and the list of components for Rundeck.
- [CSV configuration files] (./csv) - CSV files containing the different types of services and their configuration data (i.e. for each JSF, the EP to apply, the default probe priority, the service calendar, the environment...)


### Preparing your local Environment

To interact with this Repository the following steps should be performed:

> :warning: **ALL** Terraform Apply actions should be managed by the existing GitHub Workflow. Only follow this manual steps if you know what you are doing and use them only to check the Plan output and make sure the workflow will properly execute the desired actions. 

1. Make sure all the required dependencies are installed in your workstation.
    - [Terraform CLI](https://developer.hashicorp.com/terraform/cli)
    - [GCloud CLI](https://cloud.google.com/sdk/docs/install)
    - [Git CLI](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

2. Export the required variables to interact with Pagerduty, GCP and Git:
    - The `PAGERDUTY_TOKEN` API Token can be found in [Vault](https://vault.internal.epo.org/ui/vault/secrets/secret/show/all-clusters/pagerduty).

```sh
$ export GITHUB_TOKEN="YOUR_GITHUB_PAT"

$ export PAGERDUTY_TOKEN="THE_PAGERDUTY_API_TOKEN"

$ export PAGERDUTY_USER_TOKEN="YOUR_PAGERDUTY_USER_TOKEN"
```

3. Authenticate yourself usign `gcloud` CLI and save the App default login credentials:

```sh
$ gcloud init

$ gcloud auth application-default login
```

4. Clone this Repository, and create a new working branch:

```sh
$ git clone https://git.epo.org/platform/tf-pagerduty.git

$ git checkout -b YOUR_BRANCH_NAME
```

5. Inside the cloned repo directory, initialise Terraform:

```sh
$ terraform init
```

6. Now you are all set up! Before making any changes always first check that the infrastructure is up to date and nothing is missing being updated. This can happen mainly when someone did any manual intervention on Pagerduty and did not use Terraform:

```sh
$ terraform plan

# You are looking to see the following message in the end of the output:
No changes. Your infrastructure matches the configuration.
Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```

7. After following all the above mentioned steps you are free to edit the terraform code as you please and see what will be changed by re-running the `terraform plan` command. When you are happy with the outcome, its just a matter of pushing the changes to the Repository and open a Pull-Request. Once this is merged the Workflow will execute and your changes will be applied into Pagerduty.
    -  Always look into the Workflow result and make sure it was successful. In case of failure troubleshoot and fix the problem ASAP.
 
