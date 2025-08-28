Database must exist first. If not, create it:

mysql -u root -p -e "CREATE DATABASE student_info;"


If the dump file contains CREATE DATABASE statements, you can just run:

mysql -u root -p < student_info.sql
