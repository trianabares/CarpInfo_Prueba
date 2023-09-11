package com.carpinfo.controllers;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.carpinfo.models.Comentarios;
import com.carpinfo.models.Mensajes;
import com.carpinfo.models.Temas;
import com.carpinfo.services.FileUpService;
import com.carpinfo.services.ForoService;
import com.carpinfo.services.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class ForoController {
	
	private final UserService userServ;
	private final ForoService foroServ;
	private final FileUpService fileUpServ;
	
	public ForoController(UserService uServ,ForoService fServ,FileUpService fileUpServ) {
		this.userServ = uServ;
		this.foroServ = fServ;
		this.fileUpServ = fileUpServ;

	}
	
	//ruta donde se suben las fotos
	private String UPLOAD_FOLDER = "src/main/resources/static/images/";
	
	// TEMAS Y MENSAJES
	
	@GetMapping("/foro/{idTema}")
	public String mostrarTema(@PathVariable("idTema") Long idTema, @ModelAttribute("nuevomensaje") Mensajes mensaje, Model model, HttpSession sesion) {
		Long userId = (Long) sesion.getAttribute("userID");
		if (userId == null) {
			return "redirect:/registro";
		}
		Temas temas = foroServ.mostrar(idTema);
		model.addAttribute("tema", temas);
		List<Mensajes> mensajes = foroServ.findMensajesByTema(idTema);
		model.addAttribute("mensajes", mensajes);
		model.addAttribute("usuario", userServ.encontrarUserPorId(userId));
		return "tema.jsp";
	}
	
	@PostMapping("/foro/{idTema}/nuevo")
	public String addMsg(@Valid @ModelAttribute("nuevomensaje") Mensajes mensaje, BindingResult result, 
			@PathVariable("idTema") Long idTema, HttpSession sesion, Model model,
			@RequestParam("imageUpload") MultipartFile postImage) 
					throws IOException{
		Long userId = (Long) sesion.getAttribute("userID");
		if (userId == null) {
			return "redirect:/registro";
		}
		if (result.hasErrors()) {
			Temas temas = foroServ.mostrar(idTema);
			model.addAttribute("tema", temas);
			List<Mensajes> mensajes = foroServ.findMensajesByTema(idTema);
			model.addAttribute("mensajes", mensajes);
			model.addAttribute("usuario", userServ.encontrarUserPorId(userId));
			return "tema.jsp";
		}
		
		//subir foto al mensaje/post
		if(postImage == null) {
			throw new RuntimeException ("Por favor subir un archivo");
		}
		fileUpServ.subirArchivoABD(postImage);
		
		try {
			byte[] bytes = postImage.getBytes();
			Path ruta = Paths.get(UPLOAD_FOLDER, postImage.getOriginalFilename());
			Files.write(ruta, bytes);
		}catch(IOException e) {
			e.printStackTrace();
		}
	    
		mensaje.setPostImage(UPLOAD_FOLDER + postImage.getOriginalFilename());
		foroServ.addMensaje(mensaje);
		return "redirect:/foro/" + idTema.toString();
	}
	
	// MENSAJES Y COMENTARIOS
	
	@GetMapping("/foro/{idTema}/{idMensaje}")
	public String mostrarTema(@PathVariable("idTema") Long idTema, @PathVariable("idMensaje") Long idMensaje, @ModelAttribute("nuevocomentario") Comentarios comentario, Model model, HttpSession sesion) {
		Long userId = (Long) sesion.getAttribute("userID");
		if (userId == null) {
			return "redirect:/registro";
		}
		Mensajes mensaje = foroServ.mostrarMensaje(idMensaje);
		model.addAttribute("mensaje", mensaje);
		List<Comentarios> comentarios = foroServ.findComentarioByMensaje(idMensaje);
		model.addAttribute("comentarios", comentarios);
		model.addAttribute("usuario", userServ.encontrarUserPorId(userId));
		return "mensaje.jsp";
	}
	
	@PostMapping("/foro/{idTema}/{idMensaje}/nuevo")
	public String addMsg(@Valid @ModelAttribute("nuevocomentario") Comentarios comentarios, BindingResult result, @PathVariable("idTema") Long idTema, @PathVariable("idMensaje") Long idMensaje, HttpSession sesion, Model model) {
		Long userId = (Long) sesion.getAttribute("userID");
		if (userId == null) {
			return "redirect:/registro";
		}
		if (result.hasErrors()) {
			Mensajes mensajes = foroServ.mostrarMensaje(idMensaje);
			model.addAttribute("mensaje", mensajes);
			List<Comentarios> comentario = foroServ.findComentarioByMensaje(idMensaje);
			model.addAttribute("comentarios", comentario);
			model.addAttribute("usuario", userServ.encontrarUserPorId(userId));
			return "mensaje.jsp";
		} else {
			foroServ.addComentario(comentarios);
			return "redirect:/foro/" + idTema.toString() + "/" + idMensaje.toString();
		}
	}
	
}