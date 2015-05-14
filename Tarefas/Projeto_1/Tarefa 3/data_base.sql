CREATE TABLE Occurrence (
  idOccurrence INT NOT NULL,
  code INT NOT NULL,
  type VARCHAR(20) NOT NULL,
  title VARCHAR(70) NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  city VARCHAR(50) NOT NULL,
  date_time TIMESTAMP NOT NULL,
  description VARCHAR(350) NULL,
  object_1 BOOLEAN NULL,
  object_2 BOOLEAN NULL,
  object_3 BOOLEAN NULL,
  object_4 BOOLEAN NULL,
  object_5 BOOLEAN NULL,
  object_6 BOOLEAN NULL,
  object_7 BOOLEAN NULL,
  object_8 BOOLEAN NULL,
  object_9 BOOLEAN NULL,
  object_10 BOOLEAN NULL,
  object_11 BOOLEAN NULL,
  object_12 BOOLEAN NULL,
  object_13 BOOLEAN NULL,
  object_14 BOOLEAN NULL,
  object_15 BOOLEAN NULL,
  object_16 BOOLEAN NULL,
  object_17 BOOLEAN NULL,
  object_18 BOOLEAN NULL,
  object_19 BOOLEAN NULL,
  PRIMARY KEY (idOccurrence));
