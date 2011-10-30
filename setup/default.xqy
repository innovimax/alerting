xquery version "1.0-ml";

(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace demo="http://marklogic.com/samples/alerting";

import module "http://marklogic.com/samples/alerting" at "/MarkLogic/samples/alerting/constants/demo.xqy", "/modules/setup.xqy", "/MarkLogic/samples/alerting/modules/alert.xqy";

(:

if (fn:not(demo:installed-alert-config()))
then xdmp:redirect-response(fn:concat(".", $demo:APPLICATION-SETUP-PATH, "setup-alert-config.xqy"))
else if (fn:not(demo:installed-alert-triggers()))
then xdmp:redirect-response(fn:concat(".", $demo:APPLICATION-SETUP-PATH, "setup-alert-triggers-cpf.xqy"))
else if (fn:not(demo:installed-alert-cpf()))
then xdmp:redirect-response(fn:concat(".", $demo:APPLICATION-SETUP-PATH, "setup-alert-triggers-cpf.xqy"))
else if (fn:not(demo:get-actions()))
then xdmp:redirect-response(fn:concat(".", $demo:APPLICATION-SETUP-PATH, "setup-alert-actions.xqy"))
else xdmp:redirect-response(fn:concat(".", $demo:APPLICATION-DEMO-PATH))

:)


if (fn:not(demo:installed-alert-config()))
then xdmp:redirect-response("setup-alert-config.xqy")
else if (fn:not(demo:installed-alert-triggers()))
then xdmp:redirect-response("setup-alert-triggers.xqy")
else if (fn:not(demo:installed-alert-cpf()))
then xdmp:redirect-response("setup-alert-cpf.xqy")
else if (fn:not(demo:get-actions()))
then xdmp:redirect-response("setup-alert-actions.xqy")
else xdmp:redirect-response(fn:concat("..", $demo:APPLICATION-DEMO-PATH))



