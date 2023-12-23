# Rybin_SS_diplom
Rybin_SS_diplom

# Решение

Все использованные при работе файлы находятся в этом же репозитории в директории `Files`.


1. Поднимаю ВМ, балансировщик, Группы безопасности и Роутер.

<details>

<img src = "img/1.terraform/1.png" width = 100%>
<img src = "img/1.terraform/2.png" width = 100%>
<img src = "img/1.terraform/3.png" width = 100%>
<img src = "img/1.terraform/4.png" width = 100%>
<img src = "img/1.terraform/5.png" width = 100%>
<img src = "img/1.terraform/6.png" width = 100%>
<img src = "img/1.terraform/7.png" width = 100%>

</details>

----
2. Установка nginx на соответствующие машины через ansible-playbook.

<details>

<img src = "img/2.nginx/1.png" width = 100%>

</details>

Делаю запрос к Балансировщику `curl -v <публичный IP балансера>:80`. Сайт доступен по адресу Балансировщика http://158.160.130.207/

<details>

<img src = "img/2.nginx/2.png" width = 100%>

</details>

----
3. Устанавливаю на эти же машины сразу Filebeat и Zabbix-agent.

<details>

<img src = "img/3.filebeat_zabbixagent/1.png" width = 100%>

<img src = "img/3.filebeat_zabbixagent/2.png" width = 100%>

</details>

----
4. Устанавливаю Zabbix-server.пришлось устанавливать по инструкции с сайта Zabbix, включая создание базы mysql. Zabbix-server доступен по внешнему адресу http://158.160.104.38/zabbix

<details>

<img src = "img/4.zabbix_server/1.png" width = 100%>

</details>

----
5. Устанавливаю Elasticserch и проверяю запросом curl `localhost:9200/_cluster/health?pretty`.

<details>

<img src = "img/5.elastic/1.png" width = 100%>

<img src = "img/5.elastic/2.png" width = 100%>

<img src = "img/5.elastic/3.png" width = 100%>

<img src = "img/5.elastic/4.png" width = 100%>

</details>

----
6. Устанавливаю Kibana и проверяю http://158.160.122.98:5601/app/dev_tools#/console.

<details>

<img src = "img/7.kibana/1.png" width = 100%>

</details>

----

7. Создаю и поднимаю отдельно планировщик резервного копирования.

<details>
   
<img src = "img/snapshot.png" width = 100%>

</details>

----
9. Редактирую группы безопасности для некоторых ВМ. Теперь к ВМ nginx и elasticserch можно подключиться только с Bastion.

*Bastion*

<details>

<img src = "img/6.bez/bastion.png" width = 100%>

</details>

*Nginx*

<details>

<img src = "img/6.bez/nginx.png" width = 100%>

</details>

*Балансировшик*

<details>

<img src = "img/6.bez/balancer.png" width = 100%>

</details>

*Zabbix*

<details>
   
<img src = "img/6.bez/zabbix.png" width = 100%>

</details>

*Elasticsearch*

<details>
   
<img src = "img/6.bez/elastic.png" width = 100%>

<img src = "img/6.bez/elastic2.png" width = 100%>

</details>


-----
