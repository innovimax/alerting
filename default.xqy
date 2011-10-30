xquery version "1.0-ml";

(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace demo="http://marklogic.com/samples/alerting";

import module "http://marklogic.com/samples/alerting" at "/MarkLogic/samples/alerting/constants/demo.xqy";

(:
if (xdmp:has-privilege($demo:PRIVILEGE-ALERT-ADMIN, "execute") or xdmp:has-privilege($demo:PRIVILEGE-ADMIN-UI, "execute"))
:)

if (xdmp:has-privilege($demo:PRIVILEGE-ALERT-ADMIN, "execute"))
then xdmp:redirect-response(fn:concat(".", $demo:APPLICATION-SETUP-PATH))
else xdmp:redirect-response(fn:concat(".", $demo:APPLICATION-DEMO-PATH))



