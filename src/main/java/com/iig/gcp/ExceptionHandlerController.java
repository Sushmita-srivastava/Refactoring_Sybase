package com.iig.gcp;

import java.io.IOException;
import java.net.ConnectException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.ldap.CommunicationException;
import org.springframework.ldap.NamingException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class ExceptionHandlerController {

    public static final String DEFAULT_ERROR_VIEW = "error";

   
    @ExceptionHandler(value = {IOException.class})
    public ModelAndView ioErrorHandler(HttpServletRequest request, Exception e) {
        ModelAndView mav = new ModelAndView(DEFAULT_ERROR_VIEW);
        mav.addObject("datetime", new Date());
        mav.addObject("exception", "page error IN IO");
        mav.addObject("url", request.getRequestURL());
        return mav;
    }
    
    @ExceptionHandler(value = {Exception.class})
    public ModelAndView defaultErrorHandler(HttpServletRequest request, Exception e) {
        ModelAndView mav = new ModelAndView(DEFAULT_ERROR_VIEW);
        mav.addObject("datetime", new Date());
        mav.addObject("exception", "page error. please laod");
        mav.addObject("url", request.getRequestURL());
        return mav;
    }
    
 /*   @ExceptionHandler(value = { CommunicationException.class,NamingException.class,ConnectException.class})
    public ModelAndView connectionErrorHandler(HttpServletRequest request, Exception e) {
        ModelAndView mav = new ModelAndView(DEFAULT_ERROR_VIEW);
        mav.addObject("datetime", new Date());
        mav.addObject("exception","Connection Timed Out: Unable to connect. Please try after some time!");
        mav.addObject("url", request.getRequestURL());
        return mav;
    }
    
    @ExceptionHandler(value = { CommunicationException.class,NamingException.class,ConnectException.class})
    public ModelAndView oracleSyntaxErrorHandler(HttpServletRequest request, Exception e) {
        ModelAndView mav = new ModelAndView(DEFAULT_ERROR_VIEW);
        mav.addObject("datetime", new Date());
        mav.addObject("exception"," Connection Timed Out: Unable to connect. Please try after some time!");
        mav.addObject("url", request.getRequestURL());
        return mav;
    } 
    */
}
