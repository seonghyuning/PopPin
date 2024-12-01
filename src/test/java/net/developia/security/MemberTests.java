package net.developia.security;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.sql.DataSource;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations="file:**/*-context.xml")
@WebAppConfiguration
@Log4j
public class MemberTests {

   @Autowired
   private PasswordEncoder pwencoder;
   
   @Autowired
   private DataSource ds;
   
   @Ignore
   @Test
   public void testInsertUsers() {
      String sql = "insert into users(username, password) values(?,?)";
      
      for(int i=0; i < 100; i++) {
         Connection con = null;
         PreparedStatement pstmt = null;
         
         try {
            con = ds.getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setString(2, pwencoder.encode("pw" + i));
            if ( i < 80) {
               pstmt.setString(1, "user" + i);
            } else if (i < 90) {
               pstmt.setString(1, "manager" + i);
            } else {
               pstmt.setString(1, "admin" + i);
            }
            pstmt.executeUpdate();
         } catch (Exception e) {
            e.printStackTrace();
         } finally {
            if (pstmt != null) { try {pstmt.close();} catch(Exception e) {} }
            if (con   != null) { try {con.close();  } catch(Exception e) {} }
         }
      }
   }
   
   @Ignore
   @Test 
   public void testInsertAuthorities() {
      String sql = "insert into authorities (username, authority) values(?, ?)";
      for (int i = 0; i < 100; i++) {
         Connection con = null;
         PreparedStatement pstmt = null;

         try {
            con = ds.getConnection();
            pstmt = con.prepareStatement(sql);
            if (i < 80) {
               pstmt.setString(1, "user" + i);
               pstmt.setString(2, "ROLE_USER");
            } else if (i < 90) {
               pstmt.setString(1, "manager" + i);
               pstmt.setString(2, "ROLE_MEMBER");
            } else {
               pstmt.setString(1, "admin" + i);
               pstmt.setString(2, "ROLE_ADMIN");
            }
            pstmt.executeUpdate();
         } catch (Exception e) {
            e.printStackTrace();
         } finally {
            if (pstmt != null) {
               try {
                  pstmt.close();
               } catch (Exception e) {
               }
            }
            if (con != null) {
               try {
                  con.close();
               } catch (Exception e) {
               }
            }
         }
      } // end for
   }
}
