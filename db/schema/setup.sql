drop table if exists actions;
drop table if exists treaty_parties;
drop table if exists parties;
drop table if exists citations;
drop table if exists treaties;
drop table if exists action_types;
drop table if exists subjects;
drop table if exists treaty_types;

create table subjects (
	id serial,
	subject varchar(255) not null,
	primary key (id)
);

create table treaty_types (
	id serial,
	short_name varchar(5) not null,
	label varchar(12) not null,
	primary key (id)
);
insert into treaty_types (short_name, label) values ( 'BI', 'Bilateral');
insert into treaty_types (short_name, label) values ( 'MULTI', 'Multilateral');
	
create table action_types (
	id serial,
	label varchar(255) not null,
	primary key (id)
);

create table treaties (
	id serial,
	uuid char(36) not null,
	record_id int not null,
	treaty_id int not null,
	title varchar(10000) not null,
	description varchar(10000),
	signed_on varchar(255),
	in_force_on varchar(255),
	pdf_link varchar(255),
	treaty_type_id int,
	subject_id int,
	
	signed_in varchar(255),
	
	constraint fk_treaty_type foreign key (treaty_type_id) references treaty_types(id),
	constraint fk_subject foreign key (subject_id) references subjects(id),
	primary key (id)
);

create table citations (
	id serial,
	citation varchar(255) not null,
	treaty_id int not null,
	constraint fk_treaty foreign key (treaty_id) references treaties(id),
	primary key (id)
);

create table parties (
	id serial,
	name varchar(255) not null,
	downcased_name varchar(255) not null,
	primary key (id)
);

create table treaty_parties (
	id serial,
	treaty_id int not null,
	party_id int not null,
	constraint fk_treaty foreign key (treaty_id) references treaties(id),
	constraint fk_party foreign key (party_id) references parties(id),
	primary key (id)
);

create table actions (
	id serial,
	action_on date,
	effective_on date,
	treaty_id int not null,
	party_id int not null,
	action_type_id int,
	constraint fk_treaty foreign key (treaty_id) references treaties(id),
	constraint fk_party foreign key (party_id) references parties(id),
	constraint fk_action_type foreign key (action_type_id) references action_types(id),
	primary key (id)
);
