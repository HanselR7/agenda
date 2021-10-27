import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var lblContactos: UILabel!
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textEdad: UITextField!
    @IBOutlet weak var textTelefono: UITextField!
    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var btnAnterior: UIButton!
    @IBOutlet weak var btnGuardarDefinicion: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    
    var nume_contactos = 0
    var contacto_num = 0
    var id = 0
    var nombre = String()
    var edad = 0
    var telefono = String()
    var editar = false
    
    var contactos = [[Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        obtener_contactos()
        validar_contactos()
    }

    @IBAction func btnGuardar(_ sender: Any) {
        if !editar {
            let contexto = obtener_contexto_core_data()
            if textNombre.text == "" || textEdad.text == "" || textTelefono.text == "" {
                Alerta_Mensaje(title: "Datos necesarios", Mensaje: "Falta llenar datos")
            } else {
                nume_contactos += 1
                nombre = textNombre.text!
                edad = Int(textEdad.text!)!
                telefono = textTelefono.text!
                
                do {
                    let nuevo_objeto = NSEntityDescription.insertNewObject(forEntityName: "Contactos", into: contexto)
                    nuevo_objeto.setValue(nume_contactos, forKey: "id")
                    nuevo_objeto.setValue(nombre, forKey: "nombre")
                    nuevo_objeto.setValue(edad, forKey: "edad")
                    nuevo_objeto.setValue(telefono, forKey: "telefono")
                    contactos.append([id, nombre, edad, telefono])
                    try contexto.save()
                } catch {
                    print("Error")
                }
                
                vaciar_cajas()
                validar_contactos()
            }
        } else {
            
            textNombre.isUserInteractionEnabled = false
            textEdad.isUserInteractionEnabled = false
            textTelefono.isUserInteractionEnabled = false
            
            if contacto_num == (nume_contactos - 1) {
                btnSiguiente.isHidden = true
                btnAnterior.isHidden = false
            } else {
                if contacto_num == 0 {
                    btnAnterior.isHidden = true
                    btnSiguiente.isHidden = false
                } else {
                    btnSiguiente.isHidden = false
                    btnAnterior.isHidden = false
                }
            }
        }
    }
    
    @IBAction func btnCancelarPress(_ sender: Any) {
        validar_contactos()
        btnCancelar.isHidden = true
        btnGuardarDefinicion.isHidden = true
        textNombre.isUserInteractionEnabled = false
        textEdad.isUserInteractionEnabled = false
        textTelefono.isUserInteractionEnabled = false
    }
    
    @IBAction func btnSiguientePress(_ sender: Any) {
        contacto_num += 1
        if contacto_num == (nume_contactos - 1) {
            btnSiguiente.isHidden = true
            btnAnterior.isHidden = false
        } else {
            btnAnterior.isHidden = false
        }
        textNombre.text = (contactos[contacto_num][1] as! String)
        textEdad.text = "\(contactos[contacto_num][2])"
        textTelefono.text = (contactos[contacto_num][3] as! String)
    }
    
    @IBAction func btnAnteriorPress(_ sender: Any) {
        contacto_num -= 1
        if contacto_num == 0 {
            btnAnterior.isHidden = true
            btnSiguiente.isHidden = false
        } else {
            btnSiguiente.isHidden = false
        }
        textNombre.text = (contactos[contacto_num][1] as! String)
        textEdad.text = "\(contactos[contacto_num][2])"
        textTelefono.text = (contactos[contacto_num][3] as! String)
    }
    
    @IBAction func btnAgregar(_ sender: Any) {
        editar = false
        vaciar_cajas()
        textNombre.isUserInteractionEnabled = true
        textEdad.isUserInteractionEnabled = true
        textTelefono.isUserInteractionEnabled = true
        btnSiguiente.isHidden = true
        btnAnterior.isHidden = true
        btnCancelar.isHidden = false
        btnGuardarDefinicion.isHidden = false
    }
    
    @IBAction func btnEditar(_ sender: Any) {
        editar = true
        textNombre.isUserInteractionEnabled = true
        textEdad.isUserInteractionEnabled = true
        textTelefono.isUserInteractionEnabled = true
        btnSiguiente.isHidden = true
        btnAnterior.isHidden = true
        btnCancelar.isHidden = false
        btnGuardarDefinicion.isHidden = false
    }
    
    func obtener_contactos() {
        let contexto = obtener_contexto_core_data()
        let solicitud_busqueda = NSFetchRequest<NSFetchRequestResult>(entityName: "Contactos")
        do {
            let registros = try contexto.fetch(solicitud_busqueda)
            for item in registros {
                let temp = item as! NSManagedObject
                id = temp.value(forKey: "id")! as! Int
                nombre = temp.value(forKey: "nombre")! as! String
                edad = temp.value(forKey: "edad")! as! Int
                telefono = temp.value(forKey: "telefono") as! String
                contactos.append([id, nombre, edad, telefono])
            }
        } catch {
            print("Error al leer los datos")
        }
    }
    
    func validar_contactos() {
        if contactos.isEmpty {
            lblContactos.text = "Sin contactos"
            textNombre.isUserInteractionEnabled = false
            textEdad.isUserInteractionEnabled = false
            textTelefono.isUserInteractionEnabled = false
            btnSiguiente.isHidden = true
            btnAnterior.isHidden = true
        } else {
            nume_contactos = contactos.count
            lblContactos.text = "Contactos \(nume_contactos)"
            btnGuardarDefinicion.isHidden = true
            btnCancelar.isHidden = true
            textNombre.isUserInteractionEnabled = false
            textEdad.isUserInteractionEnabled = false
            textTelefono.isUserInteractionEnabled = false
            textNombre.text = (contactos[0][1] as! String)
            textEdad.text = "\(contactos[0][2])"
            textTelefono.text = (contactos[0][3] as! String)
            if contactos.count > 1 {
                btnSiguiente.isHidden = false
                btnAnterior.isHidden = true
            }
        }
    }
    
    func vaciar_cajas() {
        textNombre.text = ""
        textEdad.text = ""
        textTelefono.text = ""
    }
}

