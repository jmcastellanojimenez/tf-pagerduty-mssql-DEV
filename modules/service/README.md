# TF-Pagerduty `Service` Module

In this Module we define a template on how the Pagerduty Services managed by the K8sPlatform team should be created.

Currently the following configurations are managed:
 - The Creation of the **Technical Service**;
 - Some **Service Specific Orchestration Rules** to manage specific automations;
 - The corresponding Technical **Service Integrations**:
   - ***GitHub*** Repositories WebHooks;
   - ***Slack*** Channels.

## Support Input Variables

This Module supports the following Input Variables:

- `service_name`: The Service Name to be Created.
- `service_description`: The Service Description.
- *(optional)* `service_environment`: The Service Environment (can be 'null' for catchall services without environments).
- `service_escalation_policy`: The Service Escalation Policy to be attached to the Service.
- *(optional)* `service_urgency`: The Service Urgency. Either 'low', 'high' or 'severity_based'. Defaults to 'severity_based'.
