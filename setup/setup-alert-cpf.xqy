xquery version "1.0-ml";

(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace demo="http://marklogic.com/samples/alerting";

import module "http://marklogic.com/samples/alerting" at "/modules/setup.xqy";

demo:display-page-setup("Setup Alert Triggers and CPF", "The alert configuration does not have CPF domain IDs set.  Click OK to set them.", "install-alert-cpf")



