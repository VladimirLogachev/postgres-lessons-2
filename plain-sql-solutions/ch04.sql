-- Упражнение 4.2. Выберите все модели самолетов и соответствующие им диа- пазоны дальности полетов.
SELECT
  "model",
  "range"
FROM
  aircrafts;

-- Упражнение 4.3. Найдите все самолеты c максимальной дальностью полета:
-- 1) либобольше10000км,либоменьше4000км;
SELECT
  "model",
  "range"
FROM
  "aircrafts"
WHERE
  "range" > 10000
  OR "range" < 4000;

-- 2) больше 6 000 км, а название не заканчивается на «100»
SELECT
  "model",
  "range"
FROM
  "aircrafts"
WHERE
  "range" > 6000
  AND "model" NOT LIKE '%100';

-- Упражнение 4.4. Определите номера и время отправления всех рейсов,
-- прибывших в аэропорт назначения не вовремя.
-- ... Странно, что половина рейсов не вовремя. 15615 результатов в small
SELECT
  flight_no,
  actual_departure
FROM
  bookings.flights
WHERE
  "status" = 'Arrived'
  AND scheduled_arrival <> actual_arrival
ORDER BY
  flight_no ASC;

-- Упражнение 4.5.
-- Подсчитайте количество отмененных рейсов из аэропорта Пулково (LED),
-- как вылет, так и прибытие которых было назначено на четверг.
-- dow(sunday) = 0
-- ... В small таких записей нет
SELECT
  count(*)
FROM
  bookings.flights
WHERE
  status = 'Cancelled'
  AND departure_airport = 'LED'
  AND (extract(dow FROM scheduled_departure) = 4
    OR extract(dow FROM scheduled_arrival) = 4);

-- Упражнение 4.6. Выведите имена пассажиров, купивших билеты эконом-
-- класса за сумму, превышающую 70 000 рублей.
-- ... small = 577
SELECT
  passenger_name
FROM
  ticket_flights
  INNER JOIN tickets ON ticket_flights.ticket_no = tickets.ticket_no
WHERE
  fare_conditions = 'Economy'
  AND amount > 70000;

-- Упражнение 4.7. Напечатанный посадочный талон должен содержать фамилию и имя пассажира,
-- коды аэропортов вылета и прилета, дату и время вылета и прилета по расписанию,
-- номер места в салоне самолета.
-- Напишите запрос, выводящий всю необходимую информацию для полученных посадочных талонов на рейсы,
-- которые еще не вылетели.
-- Не вылетели:
-- - Scheduled (за месяц открывается возможность бронирования);
-- – On Time (за сутки открывается регистрация);
-- – Delayed (рейс задержан);
-- – Cancelled (отменен).
-- Фиг знает... Возможно, там нужен только On Time, потому что является следствием регистрации.
-- Вылетели:
-- – Departed (вылетел);
-- – Arrived (прибыл);
SELECT
  flight_no,
  passenger_name,
  departure_airport,
  arrival_airport,
  scheduled_departure,
  scheduled_arrival,
  seat_no
FROM
  boarding_passes
  JOIN flights ON boarding_passes.flight_id = flights.flight_id
  JOIN tickets ON boarding_passes.ticket_no = tickets.ticket_no
WHERE
  "status" IN ('On Time', 'Delayed', 'Scheduled', 'Cancelled');

