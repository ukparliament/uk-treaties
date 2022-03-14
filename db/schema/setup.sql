drop table if exists relations;
drop table if exists actions;
drop table if exists records;
drop table if exists agreements;
drop table if exists action_types;
drop table if exists subjects;
drop table if exists parties;
drop table if exists agreement_types;

create table parties (
	id serial,
	name varchar(255) not null,
	downcased_name varchar(255) not null,
	primary key (id)
);
create table action_types (
	id serial,
	label varchar(255) not null,
	primary key (id)
);

---- Good from here
create table subjects (
	id serial,
	subject varchar(255) not null,
	primary key (id)
);

create table agreement_types (
	id serial,
	short_name varchar(5) not null,
	label varchar(12) not null,
	primary key (id)
);
insert into agreement_types (short_name, label) values ( 'BI', 'Bilateral');
insert into agreement_types (short_name, label) values ( 'MULTI', 'Multilateral');

create table agreements (
	id serial,
	uuid char(36) not null,
	agreement_id int not null,
	agreement_type_id int,
	subject_id int,
	
	
	
	
	title varchar(10000) not null,
	description varchar(10000),
	signed_event_at varchar(255),
	reference_values varchar(10000),
	signed_event_on varchar(255),
	definative_eif_event_date varchar(255),
	country_name varchar(10000),
	
	constraint fk_agreement_type foreign key (agreement_type_id) references agreement_types(id),
	constraint fk_subject foreign key (subject_id) references subjects(id),
	primary key (id)
);
create table records (
	id serial,
	record_id int not null,
	lb_document_id int not null,
	agreement_id int not null,
	constraint fk_agreement foreign key (agreement_id) references agreements(id),
	primary key (id)
);
---- Good to here






create table actions (
	id serial,
	action_on date,
	effective_on date,
	action_type_id int,
	agreement_id int not null,
	party_id int not null,
	constraint fk_action_type foreign key (action_type_id) references action_types(id),
	constraint fk_agreement foreign key (agreement_id) references agreements(id),
	constraint fk_party foreign key (party_id) references parties(id),
	primary key (id)
);
create table relations (
	id serial,
	relation varchar(255) not null,
	agreement_id int,
	constraint fk_agreement foreign key (agreement_id) references agreements(id),
	primary key (id)
);