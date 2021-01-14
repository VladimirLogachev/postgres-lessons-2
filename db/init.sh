#!/bin/bash

psql -f /base/db.sql -U admin
psql -U admin -d demo -c 'ALTER ROLE admin SET search_path TO bookings'