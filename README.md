# Flutter_and_Thermal_Printer_with_USB_connection
Cara menghubungkan aplikasi Flutter dengan printer thermal dan mencetak invoice/bill menggunakan koneksi USB.<br>
How to connect Flutter App with thermal printer and print the invoice through USB connection.

<h3>Daftar Dependensi / Dependencies</h3>
1. <a href="https://pub.dev/packages/flutter_pos_printer_platform_image_3">flutter_pos_printer_platform_image_3</a><br>
2. <a href="https://pub.dev/packages/esc_pos_utils_plus">esc_pos_utils_plus</a><br>
3. <a href="https://pub.dev/packages/screenshot">screenshot</a><br>
4. <a href="https://pub.dev/packages/intl">intl</a><br><br>

Karena port USB digunakan untuk printer, maka untuk proses debug-nya melalui koneksi WIFI.<br>
Because the USB port is used for the printer, so using a WIFI connection for the debugging process.

![jaringan](https://github.com/idekorslet/Flutter_and_Thermal_Printer_with_USB_connection/assets/80518183/d00fdadd-fa7f-4831-ab62-532f30ebc6de)
<br><br>
<h3>Alur pembuatan invoice / Invoice creation flow</h3>

![invoice_flow](https://github.com/idekorslet/Flutter_and_Thermal_Printer_with_USB_connection/assets/80518183/877ed6d6-4207-495d-9166-56caaddc9927)

## Video tutorial:
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/vPEPK_9KSYs/0.jpg)](https://youtu.be/vPEPK_9KSYs)


## Support
|  |  |  |
|--|--|--|
| <a href="https://saweria.co/idekorslet"><img alt="saweria" width="180" src="https://user-images.githubusercontent.com/80518183/216806553-4a11d0ef-6257-461b-a3f2-430910574269.svg"></a> | | <a href="https://buymeacoffee.com/idekorslet"><img alt='Buy me a coffee' width="180" src="https://user-images.githubusercontent.com/80518183/216806363-a11d0282-517a-4512-9733-567e0d547078.png"> </a> |

<h3>Additional</h3>
Jika ada kendala lain misal tidak bisa konek atau printer tidak terdeteksi, bisa dicoba edit file USPrinterService.kt dan ganti kodingannya dengan file USBPrinterService.kt yg ada disini.<br>
If facing another problem such as cannot connect to the printer or the printer not detected, please try to edit the USPrinterService.kt file and replace the codes with this USPrinterService.kt codes version.<br><br>

untuk lokasi file USBPrinterService.kt ada di / the location of USPrinterService.kt:<br>
[project_folder]\print_invoice_with_usb_connection\windows\flutter\ephemeral\.plugin_symlinks\flutter_pos_printer_platform_image_3\android\src\main\kotlin\com\sersoluciones\flutter_pos_printer_platform\usb

