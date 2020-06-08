# docker-mariadb-mroonga
docker mariadb with mroonga, mecab-ipadic-neologd


## Functions

|target|function|note|
|---|---|---|
|Fulltext search|mariadb + mroonga||
|new word search|mecab-ipadic-neologd|https://github.com/neologd/mecab-ipadic-neologd |

* mecab-ipadic-neologd see
    * jp : https://engineering.linecorp.com/ja/blog/mecab-ipadic-neologd-new-words-and-expressions/
    * jp : https://kivantium.hateblo.jp/entry/2015/03/15/175612

## Install

```
docker pull japancellarjp/docker-mariadb-mroonga

git clone https://github.com/japancellarjp/docker-mariadb-mroonga.git
cd docker-mariadb-mroonga
docker run --rm \
  --name mariadb_mroonga \
  -v $(pwd)/mysql:/var/lib/mysql \
  japancellarjp/docker-mariadb-mroonga

docker exec -it mariadb_mroonga mysql -e "show engines"
docker exec -it mariadb_mroonga bash -c "mysql < /usr/share/mroonga/install.sql"
docker exec -it mariadb_mroonga mysql -e "show engines"
```


## Usage
```
docker run --rm \
  --name mariadb_mroonga \
  -v $(pwd)/mysql:/var/lib/mysql \
  -d \
  japancellarjp/docker-mariadb-mroonga

docker exec -it mariadb_mroonga mysql -e "create user test@localhost"

mysql -S mysql/mysql.sock -u test \
-e "select mroonga_command('tokenize TokenMecab \"形態素解析で問題なのはなのはのような解析が難しい単語です\" NormalizerAuto') as text\G" \
| sed "s/[\[,]/\n/g" \
| grep value \
| sed "s/{\"value\"://g"

mysql -S mysql/mysql.sock -u test \
-e "select mroonga_command('tokenize TokenMecab \"彼女はペンパイナッポーアッポーペンと恋ダンスを踊った。\" NormalizerAuto') as text\G" \
| sed "s/[\[,]/\n/g" \
| grep value \
| sed "s/{\"value\"://g"
```

```
"形態素解析"
"で"
"問題"
"な"
"の"
"は"
"なのは"
"の"
"よう"
"な"
"解析"
"が"
"難しい"
"単語"
"です"
```

```
"彼女"
"は"
"ペンパイナッポーアッポーペン"
"と"
"恋ダンス"
"を"
"踊っ"
"た"
"。"
```

## Library's Version

|production|version|url|note|
|---|---|---|---|
|centos|7.8.2003|https://hub.docker.com/_/centos/ |docker image|
|mariadb|10.4.13|http://yum.mariadb.org/10.4/centos7-amd64 ||
|groonga|10.0.3|https://packages.groonga.org/centos/ ||
|mroonga|10.03|https://packages.groonga.org/centos/ ||
|gunosy/neologd-for-mecab(neologd/mecab-ipadic-neologd)|2020.06.02|https://github.com/gunosy/neologd-for-mecab ||


## Licence

Apache License 2.0

* Library's License

|production|license|license url|note|
|---|---|---|---|
|docker|Apache-2.0|https://github.com/moby/moby/blob/master/LICENSE ||
|centos|GPL,etc|http://mirror.centos.org/centos/7/os/x86_64/EULA ||
|mariadb|GPL-2.0|https://mariadb.com/kb/en/library/mariadb-license/ ||
|groonga|LGPL-2.1|https://groonga.org/ ||
|mroonga|LGPL-2.1|https://mroonga.org/ ||
|neologd/mecab-ipadic-neologd|Apache-2.0|https://github.com/neologd/mecab-ipadic-neologd/blob/master/COPYING ||


## Author

[ihironao](https://github.com/ihironao)
