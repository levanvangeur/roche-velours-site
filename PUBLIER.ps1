Set-Location "C:\Users\Admin\Code\Site_accueil_courte_duree\roche-velours-site"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PUBLICATION LE ROCHE-VELOURS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Sauvegarde base de donnees..." -ForegroundColor Yellow
try {
    $node = "C:\Program Files\nodejs\node.exe"
    & $node -e "const{DatabaseSync}=require('node:sqlite');const db=new DatabaseSync('database.sqlite');db.exec('PRAGMA wal_checkpoint(TRUNCATE)');db.close();" 2>$null
    Write-Host "   OK" -ForegroundColor Green
} catch {
    Write-Host "   (serveur non actif, OK)" -ForegroundColor Gray
}

Write-Host "2. Ajout des modifications..." -ForegroundColor Yellow
git add -A
Write-Host "   OK" -ForegroundColor Green

Write-Host "3. Commit..." -ForegroundColor Yellow
$msg = "Mise a jour - " + (Get-Date -Format "yyyy-MM-dd HH:mm")
git commit -m $msg 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   OK" -ForegroundColor Green
} else {
    Write-Host "   Rien de nouveau a publier" -ForegroundColor Gray
}

Write-Host "4. Envoi vers GitHub..." -ForegroundColor Yellow
$push = git push origin main 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   OK - Render met a jour le site dans 2-3 min" -ForegroundColor Green
} else {
    Write-Host "   ERREUR :" -ForegroundColor Red
    Write-Host $push -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TERMINE !" -ForegroundColor Cyan
Write-Host "  https://roche-velours-site.onrender.com" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Appuyez sur Entree pour fermer"
