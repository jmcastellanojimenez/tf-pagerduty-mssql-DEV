# This file generates the different options file for Rundeck based on the service type (AMF-HTTP-JSF)
# The generated files need to be copied to rundeck installation.



resource "local_file" "svc_name_desc_app" {
content =  templatefile("${path.root}/templates/zz_component_svc.tftpl",
    {all_opts = module.legacy_app
})

filename = "zz_AMF-services.json"

}


resource "local_file" "svc_name_desc_http" {
content =  templatefile("${path.root}/templates/zz_component_svc.tftpl",
    {all_opts = module.http_instance
})

filename = "zz_HTTP-services.json"

}


resource "local_file" "svc_name_desc_jsf" {
content =  templatefile("${path.root}/templates/zz_component_svc.tftpl",
    {all_opts = module.legacy_jsf
})

filename = "zz_JSF-services.json"
}
