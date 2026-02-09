/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sportfield.dao;

/**
 *
 * @author hxhbang
 */

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import org.junit.jupiter.api.Test;

import com.sportfield.model.User;

public class UserDAOTest {
 
    private final UserDAO userDAO = new UserDAO();
    
    @Test
    public void testLoginSuccess() {
        System.out.println("Test Case 1: Login Success (Valid User/Pass)");

        String username = "admin";
        String password = "123";
        
        User result = userDAO.login(username, password);

        assertNotNull(result, "Login failed! (Returned null)");

        assertEquals("ADMIN", result.getRole(), "User role is incorrect!");
        assertEquals(username, result.getUsername(), "Username does not match!");
        
        System.out.println("Found user " + result.getFullName());
    }

    @Test
    public void testLoginWrongPassword() {
        System.out.println("Test Case 2: Login Fail (Wrong Password)");
        
        String username = "admin";
        String password = "***";
        
        User result = userDAO.login(username, password);

        assertNull(result, "Login should fail but returned User!");
        
        System.out.println("Login failed as expected.");
    }
    
    @Test
    public void testLoginNonExistUser() {
        System.out.println("Test Case 3: Login Fail (User does not exist)");
        
        String username = "user";
        String password = "123";
        
        User result = userDAO.login(username, password);
        
        assertNull(result);
        System.out.println("Non-existent user returned null.");
    }
}