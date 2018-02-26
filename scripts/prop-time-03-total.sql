
create table if not exists reass (node varchar, day date, time1 time, hash varchar, blksize int, xthinsize int, compression numeric, ip_port varchar, peerid int);
create table if not exists reass_rereq (node varchar, day date, time1 time, hash varchar, blksize int, xthinsize int, compression numeric, ip_port varchar, peerid int, txsize int);
create table if not exists bloom_filter (node varchar, day date, time1 time, size int, hash varchar, ms int);
create table if not exists received_time (node varchar, day date, time1 time, hash varchar, ip_port varchar, peerid int, xthinsize int);
create table if not exists propagation_time (node varchar, day date, time1 time, hash varchar, propagation_time numeric);
create table if not exists proc_time (node varchar, day date, time1 time, hash varchar, blktype varchar, proctime numeric, ip_port varchar, peerid int);
create table if not exists req_time (node varchar, day date, time1 time, hash varchar, ip_port varchar, peerid int);

\copy reass from reass.txt  with (format csv, delimiter ' ', header true)
\copy reass_rereq from reass-rereq.txt  with (format csv, delimiter ' ', header true)
\copy bloom_filter from bloom-filter.txt  with (format csv, delimiter ' ', header true)
\copy received_time from received.txt  with (format csv, delimiter ' ', header true)
\copy propagation_time from received2.txt  with (format csv, delimiter ' ', header true)
\copy proc_time from proctime.txt  with (format csv, delimiter ' ', header true)
\copy req_time from reqtime.txt  with (format csv, delimiter ' ', header true)

alter table reass add column txsize int;
alter table reass add column blktype varchar;
update reass  set blktype = 'xthinblock';
insert into reass (node, day, time1, hash, blksize, xthinsize, compression, ip_port, peerid, txsize, blktype) select *, 'xblocktx' from reass_rereq;

alter table reass           add column touch timestamp without time zone;
alter table bloom_filter    add column touch timestamp without time zone;
alter table received_time   add column rectime timestamp without time zone;
alter table propagation_time  add column touch timestamp without time zone;
alter table proc_time       add column touch timestamp without time zone;
alter table req_time        add column reqtime timestamp without time zone;

update reass          set touch = time1 + day;
update bloom_filter   set touch = time1 + day;
update received_time  set rectime = time1 + day;
update propagation_time set touch = time1 + day;
update proc_time      set touch = time1 + day;
update req_time       set reqtime = time1 + day;

create table total as select node, touch, hash, blksize, xthinsize, compression, ip_port, peerid from reass;
alter table total add column bloomsize int;
alter table total add column bloomtime int;
alter table total add column blktype varchar;
alter table total add column proctime numeric;
alter table total add column reqtime timestamp;
alter table total add column rectime timestamp;
alter table total add column propagationtime_computed numeric;
alter table total add column propagationtime numeric;

update total as b set bloomtime  = ms, bloomsize = size from bloom_filter as a where a.hash = b.hash and a.node = b.node;
update total as b set propagationtime = a.propagation_time from propagation_time as a where a.hash = b.hash  and a.node = b.node;
update total as b set proctime = a.proctime, blktype = a.blktype from proc_time as a where a.hash = b.hash and a.ip_port = b.ip_port  and a.node = b.node;
update total as b set reqtime = a.reqtime from req_time a where a.hash = b.hash and a.ip_port = b.ip_port and a.node = b.node;
update total as b set rectime = a.rectime from received_time a where a.hash = b.hash and a.ip_port = b.ip_port and a.node = b.node;

update total set propagationtime_computed = extract(epoch from (rectime - reqtime));

alter table total add column host varchar;
update total as b set host = a.host from peers_ip a where a.ip = split_part(b.ip_port,':',1);

