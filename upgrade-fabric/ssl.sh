# 1. commit line 
# 2. replace line with new echo


/opt/apps/fabric/fabric/upgrade/toV6.5.8/upgrade_script.sh

sed -i 's/cqlsh/cqlsh -u$1 -p$2 $3 $4 --ssl/' /opt/apps/fabric/fabric/upgrade/toV6.5.8/upgrade_script.sh


# echo "alter table k2auth${5}.roles add security_profiles set<text>;" | cqlsh -u$1 -p$2 $3 $4

echo "alter table k2auth${5}.roles add security_profiles set<text>;" | cqlsh -u$1 -p$2 $3 $4 --ssl /opt/apps/fabric/fabric/upgrade/toV6.5.8/upgrade_script.sh