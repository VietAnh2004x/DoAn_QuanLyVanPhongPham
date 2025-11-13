package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/dang-xuat") 
public class DangXuat extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy session hiện tại
            HttpSession session = request.getSession(false);

            if (session != null) {
                session.removeAttribute("authUser");
            }

            // 3. Chuyển hướng người dùng về trang chủ (servlet /Home)
            response.sendRedirect(request.getContextPath() + "/Home");
            
        } catch (IOException e) {
            // Nếu có lỗi, cũng chuyển về trang chủ
            response.sendRedirect(request.getContextPath() + "/Home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}