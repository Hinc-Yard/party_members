party_members
=============

Import data to database


1.基础数据表为1.xls

2.需要写入的表为party_members

3.party_id为组织id，需要由已知的组织名称到parties表中查询

4.retiree_id为姓名对应的id，需要由已知的name到retirees表中查询，若查不到，则放弃该行

5.join_time与join_time_in时间格式为xxxx-xx-xx

6.将基础数据表与所需要的查询数据表放在项目根目录下

7.将rake文件放在lib/tasks目录下

8.执行rake db:import_data导入数据

