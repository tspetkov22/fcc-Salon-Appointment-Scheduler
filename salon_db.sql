create database salon;

create table customers( customer_id serial primary key not null, phone varchar(15) unique not null, name varchar(50) not null);

create table appointments(appointment_id serial primary key not null, customer_id int not null, service_id int not null, time varchar(50) not null);

create table services(service_id serial primary key not null, name varchar(50) not null);

alter table appointments add foreign key (customer_id) references customers(customer_id);

alter table appointments add foreign key (service_id) references services(service_id);

insert into services(name) values ('cut'), ('color'), ('perm'), ('style'), ('trim');
