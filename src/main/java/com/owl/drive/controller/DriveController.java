package com.owl.drive.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DriveController {

		@RequestMapping("Drive.do")
		public String showview() {
			System.out.println("드라이브.do in");
			return "drive/test";
		}
		
		@RequestMapping("Trash.do")
		public String showTrashview() {
			return "drive/trash";
		}
}
