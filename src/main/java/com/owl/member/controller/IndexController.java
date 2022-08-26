package com.owl.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {

	/**
	 * index 페이지 이동
	 * @author 윤다정
	 * @since 2020/01/29
	 * @return String
	 */
	@RequestMapping("Index.do")
	public String showview() {
		return "index";
	}
}
