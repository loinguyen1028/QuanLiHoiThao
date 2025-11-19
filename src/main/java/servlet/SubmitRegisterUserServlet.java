package servlet;

import dao.RegisterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;

import java.io.IOException;

@WebServlet("/submit_register_user")
public class SubmitRegisterUserServlet extends HttpServlet {

    private RegisterDAO registerDAO;

    @Override
    public void init() {
        registerDAO = new RegisterDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int seminarId = Integer.parseInt(request.getParameter("seminarId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String userType = request.getParameter("userType");

        Register r = new Register();
        r.setSeminarId(seminarId);
        r.setName(name);
        r.setEmail(email);
        r.setPhone(phone);
        r.setUserType(userType);

        registerDAO.insert(r);

        response.sendRedirect("success.jsp");
    }
}
