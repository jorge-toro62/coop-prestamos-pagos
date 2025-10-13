-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-10-2025 a las 02:11:47
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `coop_prestamos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id` char(36) NOT NULL,
  `entidad` varchar(120) NOT NULL,
  `entidad_id` char(36) NOT NULL,
  `accion` varchar(50) NOT NULL,
  `usuario_id` char(36) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuota`
--

CREATE TABLE `cuota` (
  `id` char(36) NOT NULL,
  `prestamo_id` char(36) NOT NULL,
  `nro` int(11) NOT NULL,
  `fecha_venc` date NOT NULL,
  `capital` decimal(14,2) NOT NULL,
  `interes` decimal(14,2) NOT NULL,
  `total` decimal(14,2) NOT NULL,
  `saldo_restante` decimal(14,2) NOT NULL,
  `pagada` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `desembolso`
--

CREATE TABLE `desembolso` (
  `id` char(36) NOT NULL,
  `prestamo_id` char(36) NOT NULL,
  `monto` decimal(14,2) NOT NULL,
  `metodo` varchar(60) NOT NULL,
  `referencia` varchar(120) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `tesorero_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento`
--

CREATE TABLE `documento` (
  `id` char(36) NOT NULL,
  `socio_id` char(36) DEFAULT NULL,
  `solicitud_id` char(36) DEFAULT NULL,
  `tipo` varchar(80) NOT NULL,
  `ruta` varchar(255) NOT NULL,
  `subido_por` char(36) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `evaluacion`
--

CREATE TABLE `evaluacion` (
  `id` char(36) NOT NULL,
  `solicitud_id` char(36) NOT NULL,
  `analista_id` char(36) NOT NULL,
  `recomendacion` varchar(100) NOT NULL,
  `comentario` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medio_pago`
--

CREATE TABLE `medio_pago` (
  `codigo` varchar(40) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `medio_pago`
--

INSERT INTO `medio_pago` (`codigo`, `nombre`) VALUES
('DEBITO_AUTOMATICO', 'Débito Automático'),
('EFECTIVO', 'Efectivo'),
('TARJETA', 'Tarjeta'),
('TRANSFERENCIA', 'Transferencia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `id` char(36) NOT NULL,
  `prestamo_id` char(36) NOT NULL,
  `cuota_id` char(36) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `monto` decimal(14,2) NOT NULL,
  `medio` varchar(40) NOT NULL,
  `referencia` varchar(120) DEFAULT NULL,
  `cajero_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametro_sistema`
--

CREATE TABLE `parametro_sistema` (
  `id` char(36) NOT NULL,
  `clave` varchar(120) NOT NULL,
  `valor` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

CREATE TABLE `permiso` (
  `id` char(36) NOT NULL,
  `codigo` varchar(120) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `id` char(36) NOT NULL,
  `solicitud_id` char(36) NOT NULL,
  `socio_id` char(36) NOT NULL,
  `producto_id` char(36) NOT NULL,
  `monto` decimal(14,2) NOT NULL,
  `tasa_mensual` decimal(7,4) NOT NULL,
  `plazo_meses` int(11) NOT NULL,
  `estado` enum('VIGENTE','CANCELADO','CASTIGADO') NOT NULL DEFAULT 'VIGENTE',
  `saldo_actual` decimal(14,2) NOT NULL,
  `fecha_desembolso` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_prestamo`
--

CREATE TABLE `producto_prestamo` (
  `id` char(36) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `tipo` varchar(80) NOT NULL,
  `tasa_nominal_anual` decimal(7,4) NOT NULL,
  `plazo_max_meses` int(11) NOT NULL,
  `requisitos_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requisitos_json`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id` char(36) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
  `rol_id` char(36) NOT NULL,
  `permiso_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `id` char(36) NOT NULL,
  `nombres` varchar(191) NOT NULL,
  `documento` varchar(50) NOT NULL,
  `email` varchar(191) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `empleador` varchar(191) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO','SUSPENDIDO') NOT NULL DEFAULT 'ACTIVO',
  `fecha_alta` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitud`
--

CREATE TABLE `solicitud` (
  `id` char(36) NOT NULL,
  `socio_id` char(36) NOT NULL,
  `producto_id` char(36) NOT NULL,
  `monto` decimal(14,2) NOT NULL,
  `plazo_meses` int(11) NOT NULL,
  `ingresos` decimal(14,2) DEFAULT NULL,
  `egresos` decimal(14,2) DEFAULT NULL,
  `estado` enum('BORRADOR','ENVIADA','EN_EVALUACION','APROBADA','RECHAZADA') NOT NULL DEFAULT 'BORRADOR',
  `comentarios` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` char(36) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password_hash` varchar(191) NOT NULL,
  `nombres` varchar(191) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_rol`
--

CREATE TABLE `usuario_rol` (
  `usuario_id` char(36) NOT NULL,
  `rol_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_auditoria_entidad` (`entidad`,`entidad_id`),
  ADD KEY `fk_auditoria__usuario` (`usuario_id`);

--
-- Indices de la tabla `cuota`
--
ALTER TABLE `cuota`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cuota_prestamo_nro` (`prestamo_id`,`nro`),
  ADD KEY `idx_cuota_venc` (`fecha_venc`);

--
-- Indices de la tabla `desembolso`
--
ALTER TABLE `desembolso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_desembolso_prestamo` (`prestamo_id`),
  ADD KEY `fk_desembolso__usuario` (`tesorero_id`);

--
-- Indices de la tabla `documento`
--
ALTER TABLE `documento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_doc_socio` (`socio_id`),
  ADD KEY `idx_doc_solicitud` (`solicitud_id`),
  ADD KEY `fk_documento__usuario` (`subido_por`);

--
-- Indices de la tabla `evaluacion`
--
ALTER TABLE `evaluacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_eval_solicitud` (`solicitud_id`),
  ADD KEY `fk_evaluacion__analista` (`analista_id`);

--
-- Indices de la tabla `medio_pago`
--
ALTER TABLE `medio_pago`
  ADD PRIMARY KEY (`codigo`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pago_prestamo` (`prestamo_id`),
  ADD KEY `idx_pago_cuota` (`cuota_id`),
  ADD KEY `fk_pago__medio` (`medio`),
  ADD KEY `fk_pago__usuario` (`cajero_id`);

--
-- Indices de la tabla `parametro_sistema`
--
ALTER TABLE `parametro_sistema`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clave` (`clave`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_prestamo_solicitud` (`solicitud_id`),
  ADD KEY `idx_prestamo_socio` (`socio_id`),
  ADD KEY `fk_prestamo__producto` (`producto_id`);

--
-- Indices de la tabla `producto_prestamo`
--
ALTER TABLE `producto_prestamo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_producto_nombre` (`nombre`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD PRIMARY KEY (`rol_id`,`permiso_id`),
  ADD KEY `fk_rol_permiso__permiso` (`permiso_id`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_socio_documento` (`documento`),
  ADD UNIQUE KEY `uq_socio_email` (`email`);

--
-- Indices de la tabla `solicitud`
--
ALTER TABLE `solicitud`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_solicitud_socio` (`socio_id`),
  ADD KEY `fk_solicitud__producto` (`producto_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
  ADD PRIMARY KEY (`usuario_id`,`rol_id`),
  ADD KEY `fk_usuario_rol__rol` (`rol_id`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD CONSTRAINT `fk_auditoria__usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `cuota`
--
ALTER TABLE `cuota`
  ADD CONSTRAINT `fk_cuota__prestamo` FOREIGN KEY (`prestamo_id`) REFERENCES `prestamo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `desembolso`
--
ALTER TABLE `desembolso`
  ADD CONSTRAINT `fk_desembolso__prestamo` FOREIGN KEY (`prestamo_id`) REFERENCES `prestamo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_desembolso__usuario` FOREIGN KEY (`tesorero_id`) REFERENCES `usuario` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `documento`
--
ALTER TABLE `documento`
  ADD CONSTRAINT `fk_documento__socio` FOREIGN KEY (`socio_id`) REFERENCES `socio` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_documento__solicitud` FOREIGN KEY (`solicitud_id`) REFERENCES `solicitud` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_documento__usuario` FOREIGN KEY (`subido_por`) REFERENCES `usuario` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `evaluacion`
--
ALTER TABLE `evaluacion`
  ADD CONSTRAINT `fk_evaluacion__analista` FOREIGN KEY (`analista_id`) REFERENCES `usuario` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_evaluacion__solicitud` FOREIGN KEY (`solicitud_id`) REFERENCES `solicitud` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `fk_pago__cuota` FOREIGN KEY (`cuota_id`) REFERENCES `cuota` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pago__medio` FOREIGN KEY (`medio`) REFERENCES `medio_pago` (`codigo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pago__prestamo` FOREIGN KEY (`prestamo_id`) REFERENCES `prestamo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pago__usuario` FOREIGN KEY (`cajero_id`) REFERENCES `usuario` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `fk_prestamo__producto` FOREIGN KEY (`producto_id`) REFERENCES `producto_prestamo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prestamo__socio` FOREIGN KEY (`socio_id`) REFERENCES `socio` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prestamo__solicitud` FOREIGN KEY (`solicitud_id`) REFERENCES `solicitud` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD CONSTRAINT `fk_rol_permiso__permiso` FOREIGN KEY (`permiso_id`) REFERENCES `permiso` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rol_permiso__rol` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `solicitud`
--
ALTER TABLE `solicitud`
  ADD CONSTRAINT `fk_solicitud__producto` FOREIGN KEY (`producto_id`) REFERENCES `producto_prestamo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_solicitud__socio` FOREIGN KEY (`socio_id`) REFERENCES `socio` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
  ADD CONSTRAINT `fk_usuario_rol__rol` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuario_rol__usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
