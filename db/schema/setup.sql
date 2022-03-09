drop table if exists actions;
drop table if exists agreements;
drop table if exists action_types;
drop table if exists subjects;
drop table if exists parties;

create table parties (
	id serial,
	name varchar(255) not null,
	primary key (id)
);
create table action_types (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table subjects (
	id serial,
	subject varchar(255) not null,
	primary key (id)
);
create table agreements (
	id serial,
	title varchar(2000) not null,
	subject_id int not null,
	constraint fk_subject foreign key (subject_id) references subjects(id),
	primary key (id)
);
create table actions (
	id serial,
	action_on date,
	effective_on date,
	action_type_id int not null,
	agreement_id int not null,
	party_id int not null,
	constraint fk_action_type foreign key (action_type_id) references action_types(id),
	constraint fk_agreement foreign key (agreement_id) references agreements(id),
	constraint fk_party foreign key (party_id) references parties(id),
	primary key (id)
);