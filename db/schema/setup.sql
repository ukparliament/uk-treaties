drop table if exists agreements;
drop table if exists subjects;

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