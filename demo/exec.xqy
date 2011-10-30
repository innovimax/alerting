xquery version "1.0-ml";

(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace demo="http://marklogic.com/samples/alerting";

import module "http://marklogic.com/samples/alerting" at "/MarkLogic/samples/alerting/modules/demo.xqy";

let $param := "procedure"
let $procedure := if (xdmp:get-request-field-names() = $param and fn:not(xdmp:get-request-field($param) = "")) then xdmp:get-request-field($param) else "default"
return demo:exec($procedure)


