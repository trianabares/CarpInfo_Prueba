<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- c:out ; c:forEach etc. -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- Formateo fechas (dates) -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- Formulario form:form -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- para errores de renderizado en rutas PUT -->
<%@ page isErrorPage="true"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="ISO-8859-1">
<title>Editar Perfil</title>
<!-- BOOTSTRAP  -->
<link rel="stylesheet"
	href="/webjars/bootstrap/5.2.3/css/bootstrap.min.css">
<script src="/webjars/bootstrap/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="/style.css">
</head>

<body>
	<div id="wrapper_outter">
		<div id="wrapper_inner">
			<div id="wrapper">
				<div id="container">
					<div id="header">
						<div id="header_left">
							<div id="site_title d-flex">
								<h1>
									<a href="/"> <img src="/images/logo.png" alt="Carpinfo" /></a><span>Carpinfo</span>
								</h1>
							</div>
							<div id="menu">
								<ul>
									<li><a href="/">INFO UTIL</a></li>
									<li><a href="/turismo">TURISMO</a></li>
									<li><a href="/vecinos">VECINOS</a></li>
									<li><a href="/contacto">CONTACTO</a></li>
								</ul>
							</div>
						</div>
							<!-- end of menu -->
						<div id="header_right">
							<c:choose>
								<c:when test="${usuario.id == null }">
									<h2>Inicio de Sesi�n</h2>
									<form action="/login" method="POST">
										<label>Email</label> <input type="text" name="email"
											class="input_field" />
										<div class="cleaner"></div>
										<label>Clave</label> <input type="password" value=""
											name="password" class="input_field" />
										<div class="cleaner"></div>
										<input type="submit" name="login" value="Ingresar" alt="login"
											id="submit_btn" class="button_login" />
									</form>
									<a href="/registro">Registrarse</a>
								</c:when>
								<c:otherwise>
									<h2>
										Bienvenido,
										<c:out value="${usuario.nombre}"></c:out>
									</h2>
									<div id="fotoPerfil" class="d-flex">
										<c:choose>
											<c:when test="${usuario.profileImage != '/images/'}">
												<img class="rounded-circle" alt="Foto de perfil"
													src="${usuario.profileImage}">
											</c:when>
											<c:otherwise>
												<img class="rounded-circle" alt="Foto de perfil"
													src="/images/carpincho-icono.png">
											</c:otherwise>
										</c:choose>
										<p class="my-2">
											<a href="/perfil/${usuario.id}">Ir a mi perfil</a>
										</p>
									</div>
									<hr>
									<a href="/logout">Cerrar sesi�n</a>
								</c:otherwise>
							</c:choose>
						</div>
						<!-- end of header right -->
						<div class="cleaner"></div>
					</div>
					<!-- end of header -->
					<div id="content_wrapper">
						<div id="content_outer">
							<div id="content">
								<div class="content_section">
									<div class="text-danger my-2">
										<form:errors path="user.*" />
									</div>

									<form:form method="POST" action="/perfil/${usuario.id}/edit"
										modelAttribute="user" enctype="multipart/form-data"
										accept-charset="UTF-8">
										<input type="hidden" name="_method" value="put">
										<div class="mb-3">
											<form:label path="nombre" class="form-label">Nombre:</form:label>
											<form:input type="text" path="nombre" class="form-control" />
										</div>
										<div class="mb-3">
											<form:label path="ciudad" class="form-label">Localidad:</form:label>
											<form:input type="text" path="ciudad" class="form-control" />
										</div>

										<div class="mb-3">
											<form:label path="rol" class="form-label">Vecino o Visitante:</form:label>
											<form:select class="form-select" path="rol">
												<form:option value="select">--</form:option>
												<form:option value="vecino"> Vecino</form:option>
												<form:option value="turista"> Turista</form:option>
											</form:select>
										</div>
										<div class="mb-3">
											<form:label path="biografia" class="form-label">Biograf�a:</form:label>
											<form:textarea path="biografia" class="form-control" />
										</div>
										<div class="mb-3">
											<form:label path="edad" class="form-label">Edad:</form:label>
											<form:input type="number" path="edad" class="form-control" />
										</div>
										<form:input type="hidden" path="email" value="${usuario.email}" />
										<form:input type="hidden" path="password" value="${usuario.password}" />
										<form:input type="hidden" path="profileImage" value="${usuario.profileImage}" />
										<input type="submit" class="button_registro" value="Actualizar" alt="Actualizar" />
									</form:form>
								</div>
							</div>
							<!-- end of content -->
							<div id="content_bottom"></div>
							<div class="cleaner"></div>
						</div>
						<!-- end of content_outer -->
						<div id="template_sidebar">
							<div class="sidebar_section">
								<h2>Servicios</h2>
								<c:forEach var="publicacion" items="${publicaciones}">
									<h3>${publicacion.nombre}</h3>
									<img src="${publicacion.publiImage }" alt="" width=220px
										height=120px />
									<p class="my-2">${publicacion.contenidos}</p>
									<div class="button_01">
										<a href="${publicacion.enlace}">Ver m�s</a>
									</div>
									<c:choose>
										<c:when test="${usuario.id == 1}">
											<div>
												<form action="/servicios/${publicacion.id}/delete" method="post">
													<input type="hidden" name="_method" value="delete">
													<input  class="botoncito" type="submit"
														value="Eliminar Servicio">
												</form>
											</div>
										</c:when>
									</c:choose>
									<div class="cleaner_h30"></div>
									
								</c:forEach>
							</div>
						</div>
						<!-- end of template_sidebar -->
						<div class="cleaner"></div>
					</div>
					<!-- end of content_wrapper -->
					<div id="footer">
						<ul class="footer_menu">
							<li><a href="/">Info</a></li>
							<li><a href="/turismo">Turismo</a></li>
							<li><a href="/vecinos">Vecinos</a></li>
							<li class="last_menu"><a href="/contacto">Contacto</a></li>
						</ul>
						Copyright &copy; 2023 <a href="#">CarpInfo</a> | Designed by <a
							target="_blank" rel="nofollow" href="http://www.templatemo.com">templatemo</a>
					</div>
					<!-- end of footer -->
					<div class="cleaner"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>