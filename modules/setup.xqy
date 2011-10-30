xquery version "1.0-ml";

(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)

module namespace demo="http://marklogic.com/samples/alerting";

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace admin="http://marklogic.com/xdmp/admin";
declare namespace alert="http://marklogic.com/xdmp/alert";
declare namespace trgr="http://marklogic.com/xdmp/triggers";

import module "http://marklogic.com/xdmp/triggers" at "/MarkLogic/triggers.xqy";
import module "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module "http://marklogic.com/xdmp/alert" at "/MarkLogic/alert.xqy";
import module "http://marklogic.com/samples/alerting" at "/MarkLogic/samples/alerting/constants/alert.xqy", "/MarkLogic/samples/alerting/constants/demo.xqy", "/MarkLogic/samples/alerting/modules/demo.xqy";



(: SHOW INSTALL STEP :)

declare function demo:setup-show-step($name, $step)
{
  <div>
  {
    (
      fn:concat("Starting Installation Step ", $name, " ..."),
      $step,
      fn:concat("... Finishing Installation Step ", $name, ".")
    )
  }
  </div>
};

declare function demo:display-page-setup($title as xs:string, $description as xs:string, $procedure as xs:string)
{
  (
    xdmp:set-response-content-type('text/html'),
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">',
    <html>
      <head>{demo:include-head($title)}</head>
      <body>
        <div id="Main">
          <div>{$description}</div>
          <br />
          <form method="post" action="{fn:concat($procedure, ".xqy")}" class="action save">
            <input id="Setup" type="submit" value="OK" />
          </form>
        </div>
      </body>
    </html>
  )
};


declare function demo:display-installed-components()
as node()?
{
  <b>true</b>
};



(: ======================= ALERTS ========================== :)

declare function demo:setup-alert-config()
{
  let $config := 
    alert:make-config(
      $demo:APPLICATION-ALERT-COLLECTION,
      "Message Board",
      "Alerting configuration for the message board.",
      <alert:options>
        <alert:host>{xdmp:get-request-header("Host")}</alert:host>
      </alert:options>)

  return alert:config-insert($config)
};

declare function demo:installed-alert-config()
as xs:boolean
{
  if (alert:config-get($demo:APPLICATION-ALERT-COLLECTION)) then fn:true() else fn:false()
};

declare function demo:setup-alert-triggers()
{
  let $uri := $demo:APPLICATION-ALERT-COLLECTION
  let $trigger-ids :=
    alert:create-triggers(
      $uri,
      trgr:trigger-data-event(
        trgr:directory-scope($demo:APPLICATION-CONTENT-URI, "infinity"),
        trgr:document-content(("create", "modify")),
        trgr:pre-commit()))
  let $config := alert:config-get($uri)
  let $config := alert:config-set-trigger-ids($config, $trigger-ids)
  return alert:config-insert($config)
};

declare function demo:setup-alert-cpf()
{
  let $uri := $demo:APPLICATION-ALERT-COLLECTION
  let $config := alert:config-get($uri)
  let $config := alert:config-set-cpf-domain-names($config, ($demo:APPLICATION-CPF-DOMAIN-NAME))
  return alert:config-insert($config)
};

declare function demo:installed-alert-triggers()
as xs:boolean
{
    if (alert:config-get-trigger-ids(alert:config-get($demo:APPLICATION-ALERT-COLLECTION))) then fn:true() else fn:false()
};

declare function demo:installed-alert-cpf()
as xs:boolean
{
    if (alert:config-get-cpf-domain-names(alert:config-get($demo:APPLICATION-ALERT-COLLECTION))) then fn:true() else fn:false()
};


(:
    Note:
    For the fourth argument of alert:make-action(), 
    be sure to specify a module that will be in the modules database 
    and to insert that module in the modules database.
:)

declare function demo:setup-alert-actions()
{
  let $uri := $demo:APPLICATION-ALERT-COLLECTION
  let $action-log := alert:make-log-action()
  let $action-email-immediate := 
    alert:make-action(
      "email", 
      "Send an immediate email",
      xdmp:modules-database(),
      xdmp:modules-root(),
      "/MarkLogic/samples/alerting/modules/email.xqy",
      <alert:options/>
    )
  let $action-sms := 
    alert:make-action(
      "sms", 
      "Send an immediate SMS text message",
      xdmp:modules-database(),
      xdmp:modules-root(),
      "/MarkLogic/samples/alerting/modules/email.xqy",
      <alert:options>
        <demo:sms-providers>
          <demo:sms-provider>
            <demo:name>ATT</demo:name>
            <demo:email>txt.att.net</demo:email>
          </demo:sms-provider>
          <demo:sms-provider>
            <demo:name>Verizon</demo:name>
            <demo:email>vtext.com</demo:email>
          </demo:sms-provider>
        </demo:sms-providers>
      </alert:options>)
  let $action-email-aggregate :=
    alert:make-action(
      "aggregate",
      "Send an aggregate periodic email",
      xdmp:modules-database(),
      xdmp:modules-root(),
      "/MarkLogic/alert/log.xqy",
      <alert:options/>)

  return (
    alert:action-insert($uri, $action-log),
    alert:action-insert($uri, $action-email-immediate),
    alert:action-insert($uri, $action-sms),
    alert:action-insert($uri, $action-email-aggregate)
  )
};