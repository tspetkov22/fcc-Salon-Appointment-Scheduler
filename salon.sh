#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"

get_services_id(){

    if [[ $1 ]]; then
      echo -e "\n$1"
    fi

    list_services=$($PSQL "select * from services")
    
    echo "$list_services" | while read service_id bar service
    do
      id=$(echo $service_id | sed 's/ //g' )
      name=$(echo $service | sed 's/ //g')
      echo "$id) $service"
    done

    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in 
      [1-5]) next ;;
      *) get_services_id "I couldn't find that service. What would you like today?" ;;
    esac
}

next(){

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
 
   # CUSTOMER_PHONE_FORMATED=$(echo $CUSTOMER_PHONE | sed 's/[^0-9]*//g')
    name=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    CUSTOMER_NAME=$(echo $name | sed 's/ //g')

  if [[ -z $name ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    name=$(echo $name | sed 's/ //g')
    saved_to_table_customers=$($PSQL "insert into customers(name,phone) values('$name','$CUSTOMER_PHONE')")
  fi
  
    get_service_name=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
    service_name=$(echo $get_service_name| sed 's/ //g')
    customer_id=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  
    echo -e "\nWhat time would you like your $service_name, $CUSTOMER_NAME?"
    read SERVICE_TIME
    SAVED_TO_TABLE_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($customer_id, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
   
    if [[ $SAVED_TO_TABLE_APPOINTMENTS == "INSERT 0 1" ]]; then
      echo -e "\nI have put you down for a $service_name at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
}

get_services_id
