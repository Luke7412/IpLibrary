
import hashlib
from pathlib import Path
from string import Template


###############################################################################
file_paths = [
   Path('../rtl/Functions_pkg.vhd'),
   Path('../rtl/Identifier.vhd'),
]


###############################################################################
BLOCKSIZE = 65536
hasher = hashlib.md5()

template_file = Path('ModuleId_template.vhd')
target_id_file = Path('../rtl/ModuleId.vhd')


###############################################################################
# Calculate Hash
for file_path in file_paths:
   with file_path.open('rb') as file: 
      while True:
         buf = file.read(BLOCKSIZE)

         if len(buf) > 0:
            hasher.update(buf)
         else:
            break

hash_value = hasher.hexdigest()
print(f'MD5: {hash_value.upper()}')


# Update ID
template = Template(template_file.read_text())
updated_template = template.substitute({'hash_value': hash_value})
target_id_file.write_text(updated_template)
