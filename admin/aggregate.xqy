xquery version "1.0-ml";

(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace alert="http://marklogic.com/xdmp/alert";
declare namespace demo="http://marklogic.com/samples/alerting";

import module "http://marklogic.com/xdmp/alert" at "/MarkLogic/alert.xqy";
import module "http://marklogic.com/samples/alerting" at "/MarkLogic/samples/alerting/constants/alert.xqy", "/MarkLogic/samples/alerting/constants/demo.xqy", "/MarkLogic/samples/alerting/modules/alert.xqy", "/MarkLogic/samples/alerting/modules/demo.xqy";


let $start := xs:dateTime(xdmp:get-request-field("start"))
let $end := xs:dateTime(xdmp:get-request-field("end"))

let $rule-ids :=  fn:distinct-values(/alert:log[alert:timestamp >= $start][alert:timestamp < $end]/alert:rule-id/text())
let $rules := alert:get-all-rules($demo:APPLICATION-ALERT-COLLECTION, cts:and-query((alert:rule-id-query(($rule-ids)), alert:rule-action-query("aggregate"))))
for $rule in $rules
let $rule-id := alert:rule-get-id($rule)
let $rule-name := alert:rule-get-name($rule)
let $email := $rule/alert:options/demo:delivery/demo:email-address/text()

let $body:=
(
fn:concat(
"
************** Email sent to: ",
$email,
" ************** for rule '",
$rule-name,
"' *************

"
)
,
let $logs := /alert:log[alert:rule-id = $rule-id][alert:timestamp >= $start][alert:timestamp < $end]
for $log in $logs
let $log-created := $log/alert:timestamp/text()
let $doc-uri := $log/alert:document-uri/text()
let $doc := fn:doc($doc-uri)
let $keywords := alert:rule-get-options($rule)/demo:keywords/demo:keyword/text()
return
fn:concat(
demo:match-summary($rule, $doc, $keywords),
"

---------------------",
$log-created,
"-----------------

"
)
,
"********************************** END OF EMAIL ******************************
"
)



return

if (xdmp:has-privilege($demo:PRIVILEGE-SEND-MAIL, "execute"))
then
(

xdmp:email(
<em:Message xmlns:em="URN:ietf:params:email-xml:" xmlns:rf="URN:ietf:params:rfc822:">
    <rf:subject>Periodic-Aggregate Alert Message</rf:subject>
    <rf:from>
        <em:Address>
            <em:name>Alert System</em:name>
            <em:adrs>alert-demo@marklogic.com</em:adrs>
        </em:Address>
    </rf:from>
    <rf:to>
        <em:Address>
            <em:name>User</em:name>
            <em:adrs>{$email}</em:adrs>
        </em:Address>
    </rf:to>
    <em:content xml:space="preserve">
    {
        $body
    }
    </em:content>
</em:Message>
)

,

"Sent aggregate email."
)
else
"User does not have privilege to send aggregate email."




