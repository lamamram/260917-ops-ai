package lan.dawan.java_sb;

import java.nio.charset.Charset;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.github.javafaker.Faker;

import lan.dawan.java_sb.entities.Account;
import lan.dawan.java_sb.entities.Client;
import lan.dawan.java_sb.entities.User;
import lan.dawan.java_sb.repositories.AccountRepository;
import lan.dawan.java_sb.repositories.ClientRepository;
import lan.dawan.java_sb.repositories.UserRepository;

@SpringBootApplication
public class JavaSbApplication extends SpringBootServletInitializer {

  @Autowired
  ClientRepository clientRepository;
  @Autowired
  UserRepository userRepository;
  @Autowired
  AccountRepository accountRepository;
  @Autowired
  PasswordEncoder passwordEncoder;

  public static void main(String[] args) {
    SpringApplication.run(JavaSbApplication.class, args);
  }

  @Bean
  CommandLineRunner commandLineRunner() {
    return args -> {
      List<Account> accounts = accountRepository.findAll();
      List<Client> clients = clientRepository.findAll();
      List<User> users = userRepository.findAll();
      int maxClients = 2;
      Faker faker = new Faker();
      if (users.isEmpty()) {
        for (int i = 0; i < maxClients; i++) {
          // Create a default user
          User user = new User("user" + String.valueOf(i), "pass", "ROLE_USER");
          user.setPassword(passwordEncoder.encode(user.getPassword()));
          userRepository.save(user);
        }
        users = userRepository.findAll();
      }
      if (clients.isEmpty()) {
        List<Client> initClients = new ArrayList<Client>();
        for (int i = 0; i < maxClients; i++) {
          String firstName = faker.name().firstName();
          String lastName = faker.name().lastName();
          String name = firstName + " " + lastName;
          String email = firstName.toLowerCase().charAt(0) + lastName.toLowerCase() + "@dawan.lan";

          // Create a new Client entity
          Client client = new Client(name, email, users.get(i));
          initClients.add(client);
        }
        // Save the clients to the repository
        clientRepository.saveAll(initClients);
        clients = clientRepository.findAll();
      }
      if (accounts.isEmpty()) {
        List<Account> initAccounts = new ArrayList<Account>();
        for (Client client : clients) {
          SecureRandom random = new SecureRandom(); // Compliant for security-sensitive use cases
          byte[] array = new byte[8];
          random.nextBytes(array);
          String numero = new String(array, Charset.forName("UTF-8"));
          Account account = new Account(client, numero, 300.0f, 100.0f);
          initAccounts.add(account);
        }
        accountRepository.saveAll(initAccounts);
      }
    };
  }

}
